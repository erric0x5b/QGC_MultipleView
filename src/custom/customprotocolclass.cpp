#include "customprotocolclass.h"
#include <QDebug>

CustomProtocolClass::CustomProtocolClass(QObject *parent) : QObject{parent} {
    // create a QUDP client socket
    socket = new QUdpSocket(this);
    connect(socket, SIGNAL(readyRead()), this, SLOT(udpSocketReadyRead()));

    // Create the send timer
    sendTimer = new QTimer(this);
    connect(sendTimer, SIGNAL(timeout()), this, SLOT(timerOverflow()));
    sendCountId = 0;

    // Create pod data
    podData[0] = new PODData(this);
    podData[1] = new PODData(this);
    podCommand[0] = new PODCommand(1, this);
    podCommand[1] = new PODCommand(2, this);

    for (int i = 0; i< BUS_DEVICE; i++)
    {
        // BUS id goes from 1 to BUS_DEVICE
        busCommand[i] = new BUSCommand(i+1, this);
    }

    _parseNMEAStatus = 0;
    _busSentID = 0;
}

void CustomProtocolClass::timerOverflow() {
    QByteArray Data;
    switch (sendCountId) {
    case 0:
        qDebug() << podCommand[0]->getNMEACommand();
        Data = podCommand[0]->getNMEACommand().toUtf8();
        sendCountId = 1;
        break;
    case 1:
        Data = podCommand[1]->getNMEACommand().toUtf8();
        sendCountId = 2;
        break;
    case 2:
    default:
        Data = busCommand[_busSentID]->getNMEACommand().toUtf8();
        sendCountId = 0;
        _busSentID++;
        if ( _busSentID >=BUS_DEVICE)
        {
            _busSentID = 0;
        }
    }

    // Sends the datagram datagram
    // to the host address and at port.
    socket->writeDatagram(Data, QHostAddress("192.168.2.2"), 5400);
}

void CustomProtocolClass::startTxTimer() { sendTimer->start(100); }

void CustomProtocolClass::enable24V(int podID, bool enabled) {
    if (podID > NR_POD || podID < 1) {
        qDebug() << "Error CustomProtocolClass::enable24V invalid podID: " << podID;
    } else {
        podCommand[podID - 1]->setEnable24V(enabled);
        qDebug() << "Enable 24V changed POD: " << podID << " value: " << enabled;
    }
}

void CustomProtocolClass::enable12V(int podID, bool enabled) {
    if (podID > NR_POD || podID < 1) {
        qDebug() << "Error CustomProtocolClass::enable12V invalid podID: " << podID;
    } else {
        podCommand[podID - 1]->setEnable12V(enabled);
        qDebug() << "Enable 12V changed POD: " << podID << " value: " << enabled;
    }
}
void CustomProtocolClass::enableVMot(int podID, bool enabled) {
    if (podID > NR_POD || podID < 1) {
        qDebug() << "Error CustomProtocolClass::enableVMot invalid podID: "
                 << podID;
    } else {
        podCommand[podID - 1]->setEnableVMot(enabled);
        qDebug() << "Enable VMOT changed POD: " << podID << " value: " << enabled;
    }
}

void CustomProtocolClass::setBUSRegisterValue(int busID, int busRegister, int busValue){
    if (busID > BUS_DEVICE || busID < 1) {
        qDebug() << "Error CustomProtocolClass::enableVMot invalid busID: "
                 << busID;
    } else {
        busCommand[busID - 1]->setBusReg(busRegister);
        busCommand[busID - 1]->setBusVal(busValue);
        qDebug() << "Set Bus" <<busID<< "register " << busRegister << " value: " << busValue;
    }
}


bool CustomProtocolClass::parseNMEAMessge(const QByteArray &rxMessage) {
    for (int i = 0; i < rxMessage.size(); ++i) {
        switch (_parseNMEAStatus) {
        case 0: {
            // Wait for '$'
            if (rxMessage.at(i) == '$') {
                _completeMessage.append(rxMessage.at(i));
                _parseNMEAStatus = 1;
                _checkSumNMEA = 0;
            }
        } break;
        case 1: {
            // Wait for '*'
            if (rxMessage.at(i) != '*') {
                if (rxMessage.at(i) == '$') {
                    // Manage multiple '$'
                    _completeMessage.clear();
                    _completeMessage.append(rxMessage.at(i));
                    _parseNMEAStatus = 1;
                    _checkSumNMEA = 0;
                } else {
                    _completeMessage.append(rxMessage.at(i));
                    _checkSumNMEA = _checkSumNMEA ^ rxMessage.at(i);
                    if (_completeMessage.size() > 100) {
                        qDebug() << "CustomProtocolClass::parseNMEAMessge _completeMessage "
                                    "too big.";
                        _parseNMEAStatus = 0;
                        _completeMessage.clear();
                    }
                }
            } else {
                _completeMessage.append(rxMessage.at(i));
                _parseNMEAStatus = 2;
            }
        } break;
        case 2: {
            // Wait for CRC byte 1
            _completeMessage.append(rxMessage.at(i));
            _parseNMEAStatus = 3;
        } break;
        case 3: {
            // Wait for CRC byte 2
            _completeMessage.append(rxMessage.at(i));

            // Convert the CRC inside the _completeMessage from 'hex char' to int
            bool bStatus = false;
            QByteArray CRCArray =
                    _completeMessage.mid(_completeMessage.size() - 2, 2);
            int checksum = QString(CRCArray).toInt(&bStatus, 16);

            // Reset _parseNMEAStatus
            _parseNMEAStatus = 0;
            if (checksum == _checkSumNMEA) {
                return true;
            } else {
                qDebug() << "Eccomi" << checksum << " " << _checkSumNMEA;
                _completeMessage.clear();
            }
        } break;
        }
    }
    return false;
}

void CustomProtocolClass::udpSocketReadyRead() {
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

    // qDebug() << "Message from: " << sender.toString();
    // qDebug() << "Message port: " << senderPort;
    qDebug() << "Message: " << buffer;

    if (this->parseNMEAMessge(buffer)) {
        QList<QByteArray> buffTokens = buffer.split(',');
        if (buffTokens.length() < 2) {
            qDebug() << "Error in udpSocketReadyRead, packet too short"
                     << buffTokens.length();
            return;
        }
        if (buffTokens.at(0) == "$BAT1") {
            if (!podData[0]->parsePodData(_completeMessage)) {
                qDebug() << "Error in  parsePodData while parsing:" << _completeMessage;
            } else {
                emit pod1UpdatedData(this->podData[0]->updatedValueStringList());
            }
        } else if (buffTokens.at(0) == "$BAT2") {
            if (!podData[1]->parsePodData(_completeMessage)) {
                qDebug() << "Error in  parsePodData while parsing:" << _completeMessage;
            } else {
                emit pod2UpdatedData(this->podData[1]->updatedValueStringList());
            }
        } else {
            qDebug() << "Error CustomProtocolClass::udpSocketReadyRead() token.at(0) not currently implemented in message: " << _completeMessage;
        }
        _completeMessage.clear();
    }
}
