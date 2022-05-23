#include "buscommand.h"

BUSCommand::BUSCommand(int busID, QObject *parent)
    : QObject{parent}
{
    _busID = busID;
    _busReg = 0;
    _busVal = 0;
}


QString BUSCommand::getNMEACommand()
{
   QString nmeaCommand;
   nmeaCommand.append("$SFC,BUS,");
   nmeaCommand.append(QString::number(_busID));
   nmeaCommand.append(",");
   nmeaCommand.append(QString::number(_busReg));
   nmeaCommand.append(",");
   nmeaCommand.append(QString::number(_busVal));
   nmeaCommand.append("*");
   nmeaCommand.append(computeCRC(nmeaCommand));
   nmeaCommand.append("\r\n");
   return nmeaCommand;
}

int BUSCommand::busReg() const
{
    return _busReg;
}

void BUSCommand::setBusReg(int newBusReg)
{
    _busReg = newBusReg;
}

int BUSCommand::busVal() const
{
    return _busVal;
}

void BUSCommand::setBusVal(int newBusVal)
{
    _busVal = newBusVal;
}

QString BUSCommand::computeCRC(QString nmeaCommand)
{
    QString crcString;
    int8_t checksum;
    for (int i = 0; i< nmeaCommand.size(); i++)
    {
        switch ( nmeaCommand.at(i).toLatin1())
        {
           case '$':
               checksum  = 0;
            break;
        case '*':
        break;
        default:
            checksum = checksum^nmeaCommand.at(i).toLatin1();
        }
    }
    crcString.setNum(checksum,16);
  return crcString;
}
