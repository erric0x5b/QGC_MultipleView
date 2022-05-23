#ifndef CUSTOMPROTOCOLCLASS_H
#define CUSTOMPROTOCOLCLASS_H

#include <QObject>
#include <QUdpSocket>
#include <QTimer>
#include "poddata.h"
#include "podcommand.h"
#include "buscommand.h"

#define NR_POD      2
#define BUS_DEVICE  4


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
     * @brief setBUSRegisterValue set a register-value for the given busID
     * @param busID
     * @param busRegister
     * @param busValue
     */
    void setBUSRegisterValue(int busID, int busRegister, int busValue);

    /**
     * @brief enable24V Function used to enable/disable the 24V power supply on the ROV POD
     * @param podID can be either 1 or 2 right now
     * @param enabled TRUE to enable. FALSE to disable.
     */
    void enable24V(int podID, bool enabled);

    /**
     * @brief enable12V Function used to enable/disable the 12V power supply on the ROV POD
     * @param podID can be either 1 or 2 right now
     * @param enabled TRUE to enable. FALSE to disable.
     */
    void enable12V(int podID, bool enabled);

    /**
     * @brief enableVMOT Function used to enable/disable the VMOT power supply on the ROV POD
     * @param podID can be either 1 or 2 right now
     * @param enabled TRUE to enable. FALSE to disable.
     */
    void enableVMot(int podID, bool enabled);

private:
    QUdpSocket* socket;
    QTimer* sendTimer;
    // Array of pointer to the different POD of the ROV. Store the data received from each POD.
    PODData* podData[NR_POD];
    // Array of pointer to the different POD of the ROV. Store the command sent to each POD.
    PODCommand* podCommand[NR_POD];
    // Array of pointer to the different device attached to the BUS of the ROV.
    BUSCommand* busCommand[BUS_DEVICE];
    int sendCountId;

    QByteArray _completeMessage;
    bool parseNMEAMessge(const QByteArray& rxMessage);
    int _parseNMEAStatus;
    int8_t _checkSumNMEA;
    int8_t _busSentID; // ID of the last bus ID sent

};



#endif // CUSTOMPROTOCOLCLASS_H
