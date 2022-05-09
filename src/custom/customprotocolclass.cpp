#include "customprotocolclass.h"
#include <QDebug>

CustomProtocolClass::CustomProtocolClass(QObject *parent)
    : QObject{parent}
{
    // create a QUDP client socket
    socket = new QUdpSocket(this);
    connect(socket, SIGNAL(readyRead()), this, SLOT(udpSocketReadyRead()));

    // Create the send timer
    sendTimer = new QTimer(this);
    connect(sendTimer, SIGNAL(timeout()), this, SLOT(timerOverflow()));
    sendCountId = 0;

    // Create pod data
    podData1 = new PODData(this);
    podData2 = new PODData(this);
    _parseNMEAStatus = 0;
}

void CustomProtocolClass::timerOverflow() {
    QByteArray Data;
    switch(sendCountId){
    case 0:
        Data.append("$SFC,BAT1,FF,1,1,1,1*");
        sendCountId =1;
        break;
    case 1:
    default:
        Data.append("$SFC,BUS,1,1,1*");
        sendCountId =0;
    }

    // Sends the datagram datagram
    // to the host address and at port.
    socket->writeDatagram(Data, QHostAddress("192.168.2.2"), 5400);
}

void CustomProtocolClass::startUPD() {
    qDebug() << "Start UDP ";
    sendTimer->start(100);
}

bool CustomProtocolClass::parseNMEAMessge(const QByteArray& rxMessage) {
    for (int i = 0; i < rxMessage.size(); ++i) {
        switch( _parseNMEAStatus ){
        case 0:
        {
            // Wait for '$'
            if ( rxMessage.at(i) == '$')
            {
                _completeMessage.append(rxMessage.at(i));
                _parseNMEAStatus = 1;
                _checkSumNMEA = 0;
            }
        }break;
        case 1:
        {
            // Wait for '*'
            if ( rxMessage.at(i) != '*')
            {
                if ( rxMessage.at(i) == '$')
                {
                    // Manage multiple '$'
                    _completeMessage.clear();
                    _completeMessage.append(rxMessage.at(i));
                    _parseNMEAStatus = 1;
                    _checkSumNMEA = 0;
                }
                else {
                    _completeMessage.append(rxMessage.at(i));
                    _checkSumNMEA = _checkSumNMEA ^ rxMessage.at(i);
                    if ( _completeMessage.size()> 100){
                        qDebug() << "CustomProtocolClass::parseNMEAMessge _completeMessage too big.";
                        _parseNMEAStatus = 0;
                        _completeMessage.clear();
                    }
                }
            } else {
                _completeMessage.append(rxMessage.at(i));
                _parseNMEAStatus = 2;
            }
        }break;
        case 2:
        {
            // Wait for CRC byte 1
            _completeMessage.append(rxMessage.at(i));
            _parseNMEAStatus = 3;
        }break;
        case 3:
        {
            // Wait for CRC byte 2
            _completeMessage.append(rxMessage.at(i));

            // Convert the CRC inside the _completeMessage from 'hex char' to int
            bool bStatus = false;
            QByteArray CRCArray = _completeMessage.mid(_completeMessage.size()-2, 2);
            int checksum = QString(CRCArray).toInt(&bStatus,16);

            // Reset _parseNMEAStatus
            _parseNMEAStatus = 0;
            if (checksum == _checkSumNMEA)
            {
                return true;
            } else {
                qDebug() << "Eccomi" << checksum << " " << _checkSumNMEA;
                _completeMessage.clear();
            }
        }break;
        }
    }
    return false;
}

void CustomProtocolClass::udpSocketReadyRead(){
    // when data comes in
    QByteArray buffer;
    buffer.resize(socket->pendingDatagramSize());

    QHostAddress sender;
    quint16 senderPort;

    // qint64 QUdpSocket::readDatagram(char * data, qint64 maxSize,
    //                 QHostAddress * address = 0, quint16 * port = 0)
    // Receives a datagram no larger than maxSize bytes and stores it in data.
    // The sender's host address and port is stored in *address and *port
    // (unless the pointers are 0).
    socket->readDatagram(buffer.data(), buffer.size(), &sender, &senderPort);

    //qDebug() << "Message from: " << sender.toString();
    //qDebug() << "Message port: " << senderPort;
    qDebug() << "Message: " << buffer;

    if ( this->parseNMEAMessge(buffer) )
    {
        // Check CRC and send to the right pod (@TODO)
        if (!podData1->parsePodData(_completeMessage)){
            qDebug() << "Error in  parsePodData while parsing:" << _completeMessage;
        } else
        {
            qDebug() << "Parsed message" << podData1->debugString();
            emit customSignal(this->podData1->debugString());
        }
        _completeMessage.clear();
    }
}

PODData::PODData(QObject *parent): QObject{parent}
{
    this->vBatt = 0.0f;
    this->vMot= 0.0f;
    this->v48= 0.0f;
    this->iBatt= 0.0f;
    this->degTemp= 0.0f;
    this->digitalInput =0;
    this->vMotIn= 0;
    this->leak = 0;
}

bool PODData::parsePodData(QByteArray buffRecv){
    QList<QByteArray> buffTokens = buffRecv.split(',');
    if (buffTokens.length()!= 10)
    {
        qDebug() << "Error in  parsePodData buffTokens does not match:" << buffTokens.length();
        return false;
    }
    this->parsePodToken(buffTokens.at(2), &this->vBatt);
    this->parsePodToken(buffTokens.at(3), &this->vMot);
    this->parsePodToken(buffTokens.at(4), &this->v48);
    this->parsePodToken(buffTokens.at(5), &this->iBatt);
    this->parsePodToken(buffTokens.at(6), &this->degTemp);
    this->parsePodToken(buffTokens.at(7), &this->digitalInput);
    this->parsePodToken(buffTokens.at(8), &this->vMotIn);
    this->parsePodToken(buffTokens.at(9), &this->leak);
    return true;
}

void PODData::parsePodToken(const QByteArray &token, float * pFloatData)
{
    if (!token.isEmpty())
    {
        *pFloatData = token.toFloat();
    }
}

void PODData::parsePodToken(const QByteArray &token, int * pIntData)
{
    if (!token.isEmpty())
    {
        *pIntData = token.toInt();
    }
}

QString PODData::debugString(){
    return QString::number(this->v48);
}





