#ifndef CUSTOMPROTOCOLCLASS_H
#define CUSTOMPROTOCOLCLASS_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>

class PODData: public QObject
{
    Q_OBJECT
public:
    explicit PODData(QObject *parent = nullptr);

    bool parsePodData(QByteArray buffRecv);

    QString debugString();

private:
    float vBatt;
    float vMot;
    float v48;
    float iBatt;
    float degTemp;
    int digitalInput;
    int vMotIn;
    int leak;

    void parsePodToken(const QByteArray &token, float * pFloatData);
    void parsePodToken(const QByteArray &token, int * pIntData);
};

class CustomProtocolClass : public QObject
{
    Q_OBJECT
public:
    explicit CustomProtocolClass(QObject *parent = nullptr);

signals:
    void customSignal(QString str);

public slots:
    void startUPD();
    void udpSocketReadyRead();
    void timerOverflow();

private:
    QUdpSocket* socket;
    QTimer* sendTimer;
    PODData* podData1;
    PODData* podData2;
    int sendCountId;

    QByteArray _completeMessage;
    bool parseNMEAMessge(const QByteArray& rxMessage);
    int _parseNMEAStatus;
    int8_t _checkSumNMEA;
};



#endif // CUSTOMPROTOCOLCLASS_H
