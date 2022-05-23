#ifndef BUSCOMMAND_H
#define BUSCOMMAND_H

#include <QObject>

class BusCommand : public QObject
{
    Q_OBJECT
public:
    explicit BusCommand(int busID, QObject *parent = nullptr);
    QString getNMEACommand();
signals:
private:
    int _busID;
    int _busReg;
    int _busVal;

    //@todo remove me
    QString computeCRC(QString nmeaCommand);
};

#endif // BUSCOMMAND_H
