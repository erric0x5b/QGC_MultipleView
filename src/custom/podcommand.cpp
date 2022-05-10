#include "podcommand.h"

PODCommand::PODCommand(int podID, QObject *parent)
    : QObject{parent}
{
    enable24V = false;
    _b12VEnable = false;
    _vMotEnable = false;
    _leakOut = false;
    _digitalOut = 0;
    _podID = podID;
}


 QString PODCommand::getNMEACommand()
 {
    QString nmeaCommand;
    nmeaCommand.append("$SFC,BAT");
    nmeaCommand.append(QString::number(_podID));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(_digitalOut));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(_leakOut));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(_b12VEnable));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(enable24V));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(_vMotEnable));
    nmeaCommand.append("*");
    nmeaCommand.append(computeCRC(nmeaCommand));
    nmeaCommand.append("\r\n");
    return nmeaCommand;
 }


 QString PODCommand::computeCRC(QString nmeaCommand)
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
