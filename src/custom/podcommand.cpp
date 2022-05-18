#include "podcommand.h"

PODCommand::PODCommand(int podID, QObject *parent)
    : QObject{parent}
{
    _enable24V = false;
    _enable12V = false;
    _enableVMot = false;
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
    nmeaCommand.append(QString::number(_enable12V));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(_enable24V));
    nmeaCommand.append(",");
    nmeaCommand.append(QString::number(_enableVMot));
    nmeaCommand.append("*");
    nmeaCommand.append(computeCRC(nmeaCommand));
    nmeaCommand.append("\r\n");
    return nmeaCommand;
 }

 bool PODCommand::enable24V() const
 {
     return _enable24V;
 }

 void PODCommand::setEnable24V(bool newEnable24V)
 {
     _enable24V = newEnable24V;
 }

 bool PODCommand::enable12V() const
 {
     return _enable12V;
 }

 void PODCommand::setEnable12V(bool newEnable12V)
 {
     _enable12V = newEnable12V;
 }

 bool PODCommand::leakOut() const
 {
     return _leakOut;
 }

 void PODCommand::setLeakOut(bool newLeakOut)
 {
     _leakOut = newLeakOut;
 }

 bool PODCommand::enableVMot() const
 {
     return _enableVMot;
 }

 void PODCommand::setEnableVMot(bool newEnableVMot)
 {
     _enableVMot = newEnableVMot;
 }

 int8_t PODCommand::digitalOut() const
 {
     return _digitalOut;
 }

 void PODCommand::setDigitalOut(int8_t newDigitalOut)
 {
     _digitalOut = newDigitalOut;
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
