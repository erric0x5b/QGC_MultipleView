#include "poddata.h"

PODData::PODData(QObject *parent): QObject{parent}
{
    this->vBatt = 0.0f;
    this->vMot= 0.0f;
    this->v48= 0.0f;
    this->iBatt= 0.0f;
    this->degTemp= 0.0f;
    this->digitalInput =0;
    this->vMotIn= 0;
    this->leak = 0;
}

bool PODData::parsePodData(QByteArray buffRecv){
    QList<QByteArray> buffTokens = buffRecv.split(',');
    if (buffTokens.length()!= 10)
    {
        qDebug() << "Error in  parsePodData buffTokens does not match:" << buffTokens.length();
        return false;
    }

    if ( buffTokens.at(1) == "ENV")
    {
        this->parsePodToken(buffTokens.at(2), &this->vBatt);
        this->parsePodToken(buffTokens.at(3), &this->vMot);
        this->parsePodToken(buffTokens.at(4), &this->v48);
        this->parsePodToken(buffTokens.at(5), &this->iBatt);
        this->parsePodToken(buffTokens.at(6), &this->degTemp);
        this->parsePodToken(buffTokens.at(7), &this->digitalInput);
        this->parsePodToken(buffTokens.at(8), &this->vMotIn);
        this->parsePodToken(buffTokens.at(9), &this->leak);
    } else {
        qDebug()<< "PODData::parsePodData token 1 not currently supported";
    }
    return true;
}

void PODData::parsePodToken(const QByteArray &token, float * pFloatData)
{
    if (!token.isEmpty())
    {
        *pFloatData = token.toFloat();
    }
}

void PODData::parsePodToken(const QByteArray &token, int * pIntData)
{
    if (!token.isEmpty())
    {
        *pIntData = token.toInt();
    }
}

QStringList PODData::updatedValueStringList(){
    QStringList strList;
    strList.append(QString::number(this->vBatt));
    strList.append(QString::number(this->vMot));
    strList.append(QString::number(this->v48));
    strList.append(QString::number(this->iBatt));
    strList.append(QString::number(this->degTemp));
    strList.append(QString::number(this->digitalInput));
    strList.append(QString::number(this->vMotIn));
    strList.append(QString::number(this->leak));
    return strList;
}



