#include "buscommand.h"

BusCommand::BusCommand(int busID, QObject *parent)
    : QObject{parent}
{
    _busID = busID;
    _busReg = 0;
    _busVal = 0;
}


QString BusCommand::getNMEACommand()
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

QString BusCommand::computeCRC(QString nmeaCommand)
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
