#ifndef PODDATA_H
#define PODDATA_H

#include <QObject>

class PODData: public QObject
{
    Q_OBJECT
public:
    explicit PODData(QObject *parent = nullptr);

    bool parsePodData(QByteArray buffRecv);

    QStringList updatedValueStringList();

private:
    float vBatt;
    float vMot;
    float v48;
    float iBatt;
    float degTemp;
    int digitalInput;
    int vMotIn;
    int leak;

    void parsePodToken(const QByteArray &token, float * pFloatData);
    void parsePodToken(const QByteArray &token, int * pIntData);
};

#endif // PODDATA_H
