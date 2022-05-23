import QtQuick                  2.4
import QtPositioning            5.2
import QtQuick.Layouts          1.2
import QtQuick.Controls         1.4
import QtQuick.Dialogs          1.2
import QtGraphicalEffects       1.0

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.Palette           1.0
import QGroundControl.Vehicle           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0


Item{
    id: podRoot
    anchors.fill: parent
    
   	required property string podTitle

    signal enable24VChanged(bool checkedStatus)
    signal enable12VChanged(bool checkedStatus)
    signal enableVMotChanged(bool checkedStatus)
    
    QGCLabel{
        id:                 labelPod1
        text:               podTitle
        font.family:        ScreenTools.demiboldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.horizontalCenter:     parent.horizontalCenter
        anchors.top:        parent.top
        anchors.topMargin:  10
        anchors.rightMargin: 10
    }

    QGCLabel{
        id:                 labelBatt1
        text:               qsTr("Batt V:")
        font.family:        ScreenTools.demiboldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.left
        anchors.top:        labelPod1.bottom
        anchors.leftMargin: 10
        anchors.topMargin:  10
    }
    QGCLabel{
        id:                 labelVbat1
        text:               qsTr("00.0 V")
        font.family:        ScreenTools.normalFontFamily
        color:              "Light Green"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.horizontalCenter
        anchors.verticalCenter:   labelBatt1.verticalCenter
        anchors.leftMargin: 20
    }

    QGCLabel{
        id:                 labelIBatt1
        text:               qsTr("Batt A:")
        font.family:        ScreenTools.demiboldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.left
        anchors.top:        labelBatt1.bottom
        anchors.leftMargin: 10
        anchors.topMargin:  5
    }
    QGCLabel{
        id:                 labelIBattv1
        text:               qsTr("00.0 A")
        font.family:        ScreenTools.normalFontFamily
        color:              "Light Green"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.horizontalCenter
        anchors.verticalCenter:   labelIBatt1.verticalCenter
        anchors.leftMargin: 20
    }

    QGCLabel{
        id:                 labelV481
        text:               qsTr("Power IN:")
        font.family:        ScreenTools.demiboldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.left
        anchors.top:        labelIBatt1.bottom
        anchors.leftMargin: 10
        anchors.topMargin:  5
    }
    QGCLabel{
        id:                 labelV48v1
        text:               qsTr("00.0 V")
        font.family:        ScreenTools.normalFontFamily
        color:              "Light Green"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.horizontalCenter
        anchors.verticalCenter:   labelV481.verticalCenter
        anchors.leftMargin: 20
    }

    QGCLabel{
        id:                 labelMott1
        text:               qsTr("Mott:")
        font.family:        ScreenTools.demiboldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.top:        labelV481.bottom
        anchors.left:       parent.left
        anchors.leftMargin: 10
        anchors.topMargin:  5
    }
    QGCLabel{
        id:                 labelVmot1
        text:               qsTr("00.0 V")
        font.family:        ScreenTools.normalFontFamily
        color:              "Light Green"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.horizontalCenter
        anchors.verticalCenter:   labelMott1.verticalCenter
        anchors.leftMargin: 20
    }

    QGCLabel{
        id:                 labelTemperature1
        text:               qsTr("Temp:")
        font.family:        ScreenTools.demiboldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.left
        anchors.top:        labelMott1.bottom
        anchors.leftMargin: 10
        anchors.topMargin:  5
    }
    QGCLabel{
        id:                 labelTemperaturev1
        text:               qsTr("00.0°C")
        font.family:        ScreenTools.normalFontFamily
        color:              "Light Green"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.horizontalCenter
        anchors.verticalCenter:   labelTemperature1.verticalCenter
        anchors.leftMargin: 20
    }
/*
    QGCSwitch{
        id:                 buttonEnable12V1
        anchors.left:       parent.left
        anchors.top:        labelTemperaturev1.bottom
        anchors.topMargin:  20
        anchors.leftMargin: 10
        checked:            true

        onCheckedChanged: {
            console.log("PODSectionComponent: enable 12V checked changed: " + checked);
            podRoot.enable12VChanged(checked);
        }
        QGCLabel{
            text:               qsTr("Main 12V")
            font.family:        ScreenTools.normalFontFamily
            color:              "white"
            font.pointSize:     ScreenTools.largeFontPointSize
            anchors.left:       parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:     5
        }
    }

    QGCSwitch{
        id:                     buttonEnable24V1
        anchors.left:           parent.left
        anchors.top:            buttonEnable12V1.bottom
        anchors.topMargin:      20
        anchors.leftMargin:     10
        checked:                false

        onCheckedChanged: {
            console.log("PODSectionComponent: enable 24V checked changed: " + checked);
            podRoot.enable24VChanged(checked);
       }
        QGCLabel{
            text:               qsTr("Aux 24V")
            font.family:        ScreenTools.normalFontFamily
            color:              "white"
            font.pointSize:     ScreenTools.largeFontPointSize
            anchors.left:       parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:     5
        }
    }

    QGCSwitch{
        id:                     buttonEnableVmot1
        anchors.left:           parent.left
        anchors.top:            buttonEnable24V1.bottom
        anchors.topMargin:      20
        anchors.leftMargin:     10
        checked:                false

        onCheckedChanged: {
            console.log("PODSectionComponent: enable VMot checked changed: " + checked);
            podRoot.enableVMotChanged(checked);
        }
        QGCLabel{
            text:               qsTr("Thrusters")
            font.family:        ScreenTools.normalFontFamily
            color:              "white"
            font.pointSize:     ScreenTools.largeFontPointSize
            anchors.left:       parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin:     5
        }
    }
*/
    QGCLabel{
        id:                 labelStatus
        text:               qsTr("Status:")
        font.family:        ScreenTools.boldFontFamily
        color:              "white"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.left
        anchors.top:        labelTemperature1.bottom
        anchors.leftMargin: 10
        anchors.topMargin:  10
    }
    QGCLabel{
        id:                 labelStatusv
        text:               qsTr("GOOD")
        font.family:        ScreenTools.boldFontFamily
        color:              "Light Green"
        font.pointSize:     ScreenTools.largeFontPointSize
        anchors.left:       parent.horizontalCenter
        anchors.verticalCenter:   labelStatus.verticalCenter
        anchors.leftMargin: 20
    }

    function updateFields(strList) {
        labelVbat1.text = strList[0];
        labelVmot1.text = strList[1];
        labelV48v1.text = strList[2];
        labelIBattv1.text = strList[3];
        labelTemperaturev1.text = strList[4];
        labelDigitalIn.text = strList[5];
        labelVmotIn.text = strList[6];
        labelLeak.text = strList[7];
    }
}
