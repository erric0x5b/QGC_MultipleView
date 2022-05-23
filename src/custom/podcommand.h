#ifndef PODCOMMAND_H
#define PODCOMMAND_H

#include <QObject>

class PODCommand : public QObject
{
    Q_OBJECT
public:
    explicit PODCommand(int podID, QObject *parent = nullptr);
    QString getNMEACommand();

    bool enable24V() const;
    void setEnable24V(bool newEnable24V);

    bool enable12V() const;
    void setEnable12V(bool newEnable12V);

    bool leakOut() const;
    void setLeakOut(bool newLeakOut);

    bool enableVMot() const;
    void setEnableVMot(bool newEnableVMot);

    int8_t digitalOut() const;
    void setDigitalOut(int8_t newDigitalOut);

signals:

private:
    bool _enable24V;
    bool _enable12V;
    bool _enableVMot;
    bool _leakOut;
    int8_t _digitalOut;

    int _podID;

     QString computeCRC(QString nmeaCommand);
};

#endif // PODCOMMAND_H
