#ifndef PODCOMMAND_H
#define PODCOMMAND_H

#include <QObject>

class PODCommand : public QObject
{
    Q_OBJECT
public:
    explicit PODCommand(int podID, QObject *parent = nullptr);
    QString getNMEACommand();
signals:

private:
    bool enable24V;
    bool _b12VEnable;
    bool _vMotEnable;
    bool _leakOut;
    int8_t _digitalOut;

    int _podID;

     QString computeCRC(QString nmeaCommand);
};

#endif // PODCOMMAND_H
