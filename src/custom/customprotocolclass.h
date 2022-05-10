#ifndef CUSTOMPROTOCOLCLASS_H
#define CUSTOMPROTOCOLCLASS_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include "poddata.h"
#include "podcommand.h"


class CustomProtocolClass : public QObject
{
    Q_OBJECT
public:
    explicit CustomProtocolClass(QObject *parent = nullptr);

signals:
    /**
     * @brief pod1UpdatedData signal sent from the CustomProtocolClass to the QML to update the POD1 data
     * @param strList list of values provided by the POD
     */
    void pod1UpdatedData(QStringList strList);
    /**
     * @brief pod1UpdatedData signal sent from the CustomProtocolClass to the QML to update the POD1 data
     * @param strList list of values provided by the POD
     */
    void pod2UpdatedData(QStringList strList);

public slots:
    /**
     * @brief startTxTimer Start the 100ms transmission timer
     */
    void startTxTimer();
    /**
     * @brief udpSocketReadyRead UDP socket slot called every time we received new bytes from the ROV telemetry serial
     */
    void udpSocketReadyRead();
    /**
     * @brief timerOverflow timer overflow slot called every 100ms to send a new UDP packet to the ROV telemetry
     */
    void timerOverflow();

    /**
     * @brief enable24V Function used to enable/disable the 24V power supply on the ROV
     * @param enabled
     */
    void enable24V(bool enabled);

private:
    QUdpSocket* socket;
    QTimer* sendTimer;
    PODData* podData1;
    PODData* podData2;
    PODCommand* podCommand1;
    PODCommand* podCommand2;
    int sendCountId;

    QByteArray _completeMessage;
    bool parseNMEAMessge(const QByteArray& rxMessage);
    int _parseNMEAStatus;
    int8_t _checkSumNMEA;

};



#endif // CUSTOMPROTOCOLCLASS_H
