#ifndef BUSCOMMAND_H
#define BUSCOMMAND_H

#include <QObject>

class BUSCommand : public QObject
{
    Q_OBJECT
public:
    explicit BUSCommand(int busID, QObject *parent = nullptr);
    QString getNMEACommand();
    int busReg() const;
    void setBusReg(int newBusReg);

    int busVal() const;
    void setBusVal(int newBusVal);

signals:
private:
    int _busID;
    int _busReg;
    int _busVal;

    //@todo remove me
    QString computeCRC(QString nmeaCommand);
};

#endif // BUSCOMMAND_H
