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

import QtQuick.Window       2.15
import QtQuick              2.15
import QtQuick.Controls     2.15

import org.freedesktop.gstreamer.GLVideoItem 1.0

import "." as QGroundMain;

ApplicationWindow {
    id:             multiVideoWindow
    title:          "Multi-Video Context"
    width:          1280
    height:         720
    //    minimumWidth:   width
    //    minimumHeight:  height
    //    maximumWidth:   width
    //    maximumHeight:  height
    visible:        true

    onClosing: function() {
        QGroundControl.videoManager.stopMultiCamRecording();
    }

    Item {
        anchors.fill: parent
        Rectangle {
            id:             noVideo0
            width:          parent.width/2
            height:         parent.height/2
            x:              parent.width/2
            y:              0
            color:          Qt.rgba(0,0,0,0.75)
            border.width:   1
            visible:        !(QGroundControl.videoManager.decoding0)
            QGCLabel {
                text:               qsTr("WAITING FOR VIDEO 1")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.centerIn:   parent
            }
        }
        GstGLVideoItem {
            objectName: "videoContent0"
            width: parent.width/2
            height: parent.height/2
            x: parent.width/2
            y: 0
            property var receiver
            visible: QGroundControl.videoManager.decoding0
        }
    }

    Item {
        anchors.fill: parent
        Rectangle {
            id:             noVideo1
            width:          parent.width/2
            height:         parent.height/2
            x:              parent.width/2
            y:              parent.height/2
            color:          Qt.rgba(0,0,0,0.75)
            border.width:   1
            visible:        !(QGroundControl.videoManager.decoding1)
            QGCLabel {
                text:               qsTr("WAITING FOR VIDEO 2")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.centerIn:   parent
            }
        }
        GstGLVideoItem {
            objectName: "videoContent1"
            width: parent.width/2
            height: parent.height/2
            x: parent.width/2
            y: parent.height/2
            property var receiver
            visible: QGroundControl.videoManager.decoding1
        }
    }
/*
    Item {
        anchors.fill: parent
        Rectangle {
            id:             noVideo2
            width:          parent.width/2
            height:         parent.height/2
            x:              parent.width/2
            y:              parent.height/2
            color:          Qt.rgba(0,0,0,0.75)
            visible:        !(QGroundControl.videoManager.decoding2)
            QGCLabel {
                text:               qsTr("WAITING FOR VIDEO 3")
                font.family:        ScreenTools.demiboldFontFamily
                color:              "white"
                font.pointSize:     ScreenTools.largeFontPointSize
                anchors.centerIn:   parent
            }
        }
        GstGLVideoItem {
            objectName: "videoContent2"
            width: parent.width/2
            height: parent.height/2
            x: parent.width/2
            y: parent.height/2
            property var receiver
            visible: QGroundControl.videoManager.decoding2
        }
    }
*/





    //ROV DATA
    Item{
        Rectangle{
            id:                     dataSpace
            color:                  "transparent"
            gradient: Gradient {
                GradientStop {
                    position: 0.29;
                    color: "#141033";
                }
                GradientStop {
                    position: 1.00;
                    color: "#041082";
                }
            }
            visible: true
            border.width: 1
            width:                  multiVideoWindow.width/2
            height:                 multiVideoWindow.height
            x:                      0
            y:                      0


            //POD 1
            Rectangle{
                id:                     pod1Section
                color:                  Qt.rgba(0,0,0,0.40)
                visible: true
                border.width: 1
                radius:                 10
                width:                  dataSpace.width/4
                height:                 dataSpace.height/3-10
                anchors.left:           dataSpace.left
                anchors.top:            dataSpace.top
                anchors.topMargin:      5
                anchors.leftMargin:     5


                PODSectionComponent{
                    id: pod1Data;
                    anchors.fill: parent
                    podTitle : qsTr("POD 1")
/*
                    onEnable24VChanged: {
                        QGroundControl.customProtocol.enable24V(1, checkedStatus);
                    }
                    onEnable12VChanged: {
                        QGroundControl.customProtocol.enable12V(1, checkedStatus);
                    }
                    onEnableVMotChanged:{
                         QGroundControl.customProtocol.enableVMot(1, checkedStatus);
                    }*/
                }
            }

            //POD 2
            Rectangle{
                id:                     pod2Section
                color:                  Qt.rgba(0,0,0,0.40)
                visible:                true
                border.width:           1
                radius:                 10
                width:                  dataSpace.width/4
                height:                 dataSpace.height/3-10
                anchors.left:           pod1Section.right
                anchors.top:            dataSpace.top
                anchors.leftMargin:     5
                anchors.topMargin:     5

                PODSectionComponent{
                    id: pod2Data;
                    anchors.fill: parent
                    podTitle : qsTr("POD 2")
/*
                    onEnable24VChanged: {
                        QGroundControl.customProtocol.enable24V(2, checkedStatus);
                    }
                    onEnable12VChanged: {
                        QGroundControl.customProtocol.enable12V(2, checkedStatus);
                    }
                    onEnableVMotChanged:{
                         QGroundControl.customProtocol.enableVMot(2, checkedStatus);
                    }*/
                }
            }

            //CONTROLLS
            Rectangle{
                id:                     controlls
                color:                  Qt.rgba(0,0,0,0.40)
                visible:                true
                border.width:           1
                radius:                 10
                width:                  dataSpace.width/3
                height:                 dataSpace.height/3-10
                anchors.left:           pod2Section.right
                anchors.top:            dataSpace.top
                anchors.leftMargin:     5
                anchors.topMargin:     5

                // socket test button
                QGCButton{
                    id:                 buttonSocket
                    objectName:         "buttonSocket"
                    text:               qsTr("Start TX")
                    anchors.left:       controlls.left
                    anchors.top:        controlls.top
                    anchors.topMargin:  10
                    anchors.leftMargin: 10

                    onClicked: {
                        QGroundControl.customProtocol.startTxTimer()
                    }
                }

                // Recording button
                Item {
                    Layout.alignment:   Qt.AlignHCenter
                    width:              ScreenTools.defaultFontPixelWidth * 6
                    height:             width
                    id:                 recordingRect
                    anchors.left:       controlls.left
                    anchors.top:        buttonSocket.bottom
                    anchors.topMargin:  10
                    anchors.leftMargin: 10

                    Rectangle {
                        color: Qt.rgba(0,0,0,1)
                        width: parent.width
                        height: time.height
                        anchors.centerIn: parent
                    }

                    // Start recording button
                    Rectangle {
                        id: circle
                        anchors.centerIn:   parent
                        width:              parent.width * 0.5
                        height:             width
                        radius:             width * 0.75
                        color:              Qt.rgba(1,0,0,1)
                    }

                    // Stop recording button
                    Rectangle {
                        id: square
                        anchors.centerIn:   parent
                        width:              parent.width * 0.5
                        height:             width
                        color:              Qt.rgba(1,1,1,1)
                        visible:            !circle.visible
                    }

                    function beginRecording() {
                        recordingRect.passedTime = new Date();
                        recordingRect.passedMs = 0;
                        timer.running = true;
                        QGroundControl.videoManager.startMultiCamRecording();
                    }

                    function endRecording() {
                        recordingRect.passedTime = new Date();
                        recordingRect.passedMs = 0;
                        time.text = recordingRect.timeItemFormat(recordingRect.passedMs);
                        timer.running = false;
                        QGroundControl.videoManager.stopMultiCamRecording();
                    }

                    // Actual button
                    MouseArea {
                        anchors.fill:   parent
                        enabled:        true
                        onClicked: function() {
                            // Toggle: yes it is hacky, but it works
                            if (circle.visible) {
                                circle.visible = false;
                                recordingRect.beginRecording();
                            } else {
                                circle.visible = true;
                                recordingRect.endRecording();
                            }
                        }
                    }

                    property date passedTime: new Date()
                    property int passedMs: 0

                    function pad(num, len) {
                        var result = num.toString();
                        while (result.length < len) {
                            result = "0" + result;
                        }
                        return result;
                    }

                    function timeItemFormat(num) {
                        var result = "";
                        var milliseconds = Math.floor(num % 100);
                        var seconds = Math.floor(num / 1000 % 60);
                        var minutes = Math.floor(num / 1000 / 60);
                        result = pad(minutes, 2) + ":" + pad(seconds, 2) + ":" + pad(milliseconds, 2);
                        return result;
                    }

                    Timer {
                        id: timer
                        interval: 1
                        running: false
                        repeat: true
                        onTriggered: function() {
                            recordingRect.passedMs += new Date() - recordingRect.passedTime;
                            recordingRect.passedTime = new Date();
                            time.text = recordingRect.timeItemFormat(recordingRect.passedMs);
                        }
                    }

                    Rectangle {
                        id: recordingWhiteRectangle
                        color: "white"
                        anchors.verticalCenter: circle.verticalCenter
                        anchors.left: circle.right
                        anchors.leftMargin: 10
                        Text {
                            id: time
                            horizontalAlignment: Text.AlignHCenter
                            anchors.verticalCenter: circle.verticalCenter
                            anchors.left: circle.right
                            anchors.leftMargin: 10
                            text:  "00:00:00"
                            color: "black"
                            font.family: ScreenTools.demiboldFontFamily
                            font.pixelSize: 20
                        }
                        width: childrenRect.width
                        height: childrenRect.height
                        x: childrenRect.x
                        y: childrenRect.y
                    }
                }
            }

            //Source Select
            Rectangle{
                id:                     sourceSelect
                color:                  Qt.rgba(0,0,0,0.30)
                visible:                true
                border.width:           1
                radius:                 10
                width:                  multiVideoWindow.width/16
                height:                 multiVideoWindow.height/3-10
                anchors.left:           controlls.right
                anchors.top:            dataSpace.top
                anchors.leftMargin:     5
                anchors.topMargin:      5

                QGCLabel{
                    id:                 labelVideoSource
                    text:               qsTr("Source")
                    font.family:        ScreenTools.demiboldFontFamily
                    color:              "white"
                    font.pointSize:     ScreenTools.largeFontPointSize
                    anchors.horizontalCenter:     sourceSelect.horizontalCenter
                    anchors.top:        sourceSelect.top
                    anchors.topMargin:  10
                    anchors.rightMargin: 10
                }

                // video 1 select button
                QGCButton{
                    id:                 buttonVideo1
                    objectName:         "buttonSocket"
                    text:               qsTr("Video 1")
                    anchors.horizontalCenter:       sourceSelect.horizontalCenter
                    anchors.top:        labelVideoSource.bottom
                    anchors.topMargin:  10
                    width:              parent.width - 10

                    onClicked: {
                        QGroundControl.customProtocol.startTxTimer()
                    }
                }

                // video 2 select button
                QGCButton{
                    id:                 buttonVideo2
                    objectName:         "buttonSocket"
                    text:               qsTr("Video 2")
                    anchors.horizontalCenter:       sourceSelect.horizontalCenter
                    anchors.top:        buttonVideo1.bottom
                    anchors.topMargin:  10
                    width:              parent.width - 10

                    onClicked: {
                        QGroundControl.customProtocol.startTxTimer()
                    }
                }

                // MAP select button
                QGCButton{
                    id:                 buttonMap
                    objectName:         "buttonSocket"
                    text:               qsTr("MAP")
                    anchors.horizontalCenter:       sourceSelect.horizontalCenter
                    anchors.top:        buttonVideo2.bottom
                    anchors.topMargin:  10
                    width:              parent.width - 10

                    onClicked: {
                        QGroundControl.customProtocol.startTxTimer()
                    }
                }
            }

            //Swipe view
            Rectangle{
                id:                     swipeView
                color:                  Qt.rgba(0,0,0,0.40)
                visible:                true
                border.width:           1
                radius:                 10
                width:                  multiVideoWindow.width/2-10
                height:                 multiVideoWindow.height/2-10
                anchors.left:           dataSpace.left
                anchors.top:            pod1Section.bottom
                anchors.leftMargin:     5
                anchors.topMargin:      5

                SwipeView {
                    id: stackLayout
                    width: 100
                    anchors.top: tabBar.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    currentIndex: tabBar.currentIndex

                    onCurrentIndexChanged: tabBar.currentIndex = stackLayout.currentIndex

                    Item {
                        Label {
                            //text: qsTr("Main")
                            anchors.centerIn: parent
                            font: Constants.largeFont
                        }
                        Rectangle {
                            width: 630
                            height: 320
                            color: "transparent"
                            border.color: "#00000000"

                            QGCLabel{
                                id:     labelOnOf
                                text:   qsTr("ON/OFF")
                                font:   ScreenTools.deminormalFontFamily
                                anchors.horizontalCenter:   switchLight1.horizontalCenter
                                anchors.top:    parent.top
                                anchors.topMargin:  10
                            }

                            QGCLabel{
                                id:     labelLights
                                text:   qsTr("LIGHTS")
                                font:   ScreenTools.demiboldFontFamily
                                anchors.horizontalCenter:   sliderLight1.horizontalCenter
                                anchors.verticalCenter:     labelOnOf.verticalCenter
                            }

                            QGCLabel{
                                id:     labelGroup
                                text:   qsTr("GROUP")
                                font:   ScreenTools.deminormalFontFamily
                                anchors.horizontalCenter:   switchGroup1.horizontalCenter
                                anchors.verticalCenter:     labelOnOf.verticalCenter
                            }

                            QGCSwitch {
                                id: switchLight1
                                anchors.top:    labelOnOf.bottom
                                anchors.left:   parent.left
                                anchors.leftMargin: 10
                                anchors.topMargin: 20

                                onCheckedChanged: {
                                    if ( switchLight1.checked)
                                    {
                                        // Turn on
                                        QGroundControl.customProtocol.setBUSRegisterValue(1,1,1);
                                    } else {
                                        // Turn on
                                        QGroundControl.customProtocol.setBUSRegisterValue(1,1,0);
                                    }
                                }
                            }

                            QGCSlider {
                                id: sliderLight1
                                anchors.verticalCenter:    switchLight1.verticalCenter
                                anchors.left:   switchLight1.right
                                anchors.leftMargin: 20
                                width: 170
                                minimumValue:   0
                                maximumValue:   255
                                onValueChanged: {
                                    QGroundControl.customProtocol.setBUSRegisterValue(1,5,sliderLight1.value);
                                }
                            }

                            QGCSwitch {
                                id: switchGroup1
                                anchors.verticalCenter:     sliderLight1.verticalCenter
                                anchors.left:               sliderLight1.right
                                anchors.leftMargin:         20
                            }

                            QGCSwitch {
                                id: switchLight2
                                anchors.horizontalCenter:   switchLight1.horizontalCenter
                                anchors.top:                switchLight1.bottom
                                anchors.topMargin:  20

                                onCheckedChanged: {
                                    if ( switchLight2.checked)
                                    {
                                        // Turn on
                                        QGroundControl.customProtocol.setBUSRegisterValue(2,1,1);
                                    } else {
                                        // Turn on
                                        QGroundControl.customProtocol.setBUSRegisterValue(2,1,0);
                                    }
                                }
                            }

                            QGCSlider {
                                id: sliderLight2
                                anchors.verticalCenter:     switchLight2.verticalCenter
                                anchors.horizontalCenter:   sliderLight1.horizontalCenter
                                width: 170
                                minimumValue:   0
                                maximumValue:   255
                                onValueChanged: {
                                    QGroundControl.customProtocol.setBUSRegisterValue(2,5,sliderLight2.value);
                                }
                            }

                            QGCSwitch {
                                id: switchGroup2
                                anchors.verticalCenter:     sliderLight2.verticalCenter
                                anchors.left:               sliderLight2.right
                                anchors.leftMargin:         20
                            }

                            QGCSwitch {
                                id: switchLight3
                                anchors.horizontalCenter:   switchLight1.horizontalCenter
                                anchors.top:                switchLight2.bottom
                                anchors.topMargin:  20

                                onCheckedChanged: {
                                    if ( switchLight3.checked)
                                    {
                                        // Turn on
                                        QGroundControl.customProtocol.setBUSRegisterValue(3,1,1);
                                    } else {
                                        // Turn on
                                        QGroundControl.customProtocol.setBUSRegisterValue(3,1,0);
                                    }
                                }
                            }

                            QGCSlider {
                                id: sliderLight3
                                anchors.verticalCenter:     switchLight3.verticalCenter
                                anchors.horizontalCenter:   sliderLight1.horizontalCenter
                                width: 170
                                minimumValue:   0
                                maximumValue:   255
                                onValueChanged: {
                                    QGroundControl.customProtocol.setBUSRegisterValue(3,5,sliderLight3.value);
                                }
                            }

                            QGCSwitch {
                                id: switchGroup3
                                anchors.verticalCenter:     sliderLight3.verticalCenter
                                anchors.left:               sliderLight3.right
                                anchors.leftMargin:         20
                            }

                            QGCButton {
                                id: buttonAutoHeading
                                x: 374
                                y: 23
                                text: qsTr("HEADING")
                            }

                            QGCButton {
                                id: buttonAutoDepth
                                x: 374
                                y: 77
                                width: 76
                                text: qsTr("DEPTH")
                            }

                            QGCButton {
                                id: buttonAutoAlti
                                x: 374
                                y: 131
                                width: 76
                                text: qsTr("ALTI")
                            }

                            DelayButton {
                                id: delayButtonThruster
                                x: 374
                                y: 185
                                text: qsTr("TH. ENANLE")
                                display: AbstractButton.TextBesideIcon
                                checked: false
                                delay: 2000
                            }

                            SpinBox {
                                id: spinBoxTilt
                                x: 88
                                y: 239
                                height: 30
                                anchors.verticalCenter: buttonTilt.verticalCenter
                                to: 90
                                from: -90
                                editable: true
                            }

                            QGCButton {
                                id: buttonTilt
                                x: 12
                                y: 239
                                text: qsTr("TILT RST")
                            }

                            QGCSwitch {
                                id: switchLaser
                                anchors.verticalCenter: buttonTilt.verticalCenter
                                anchors.right:          toolSeparator.left
                                anchors.rightMargin:    10
                            }

                            ToolSeparator {
                                id: toolSeparator
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: 15
                                height: 264
                            }

                            SpinBox {
                                id: spinBoxHdg
                                x: 456
                                y: 23
                                width: 166
                                height: 30
                                anchors.verticalCenter: buttonAutoHeading.verticalCenter
                                to: 359
                            }

                            SpinBox {
                                id: spinBoxAlti
                                x: 456
                                y: 131
                                width: 166
                                height: 30
                                anchors.verticalCenter: buttonAutoAlti.verticalCenter
                                value: 50
                                to: 50
                            }

                            SpinBox {
                                id: spinBoxDpt
                                x: 456
                                y: 77
                                width: 166
                                height: 30
                                anchors.verticalCenter: buttonAutoDepth.verticalCenter
                                value: 0
                                to: 0
                                from: -500
                            }

                        }
                    }

                    Item {
                        Label {
                            //text: qsTr("I/O")
                            anchors.centerIn: parent
                            font: Constants.largeFont
                        }

                    }

                    Item {
                        Label {
                            //text: qsTr("DIAG")
                            anchors.centerIn: parent
                            font: Constants.largeFont
                        }
                    }

                    Item {
                        Label {
                            //text: qsTr("LOG")
                            anchors.centerIn: parent
                            font: Constants.largeFont
                        }
                    }


                }

                QGCTabBar {
                    id: tabBar
                    //height: 48
                    currentIndex: 0
                    anchors.top: parent.top
                    anchors.leftMargin: 0
                    anchors.right: stackLayout.right
                    anchors.left: stackLayout.left


                    QGCTabButton {
                        text: qsTr("MAIN")
                        font:   ScreenTools.demiboldFontFamily
                    }

                    QGCTabButton {
                        text: qsTr("I/O")
                        font:   ScreenTools.demiboldFontFamily
                    }

                    QGCTabButton {
                        text: qsTr("DIAG")
                        font:   ScreenTools.demiboldFontFamily
                    }

                    QGCTabButton {
                        text: qsTr("LOG")
                        font:   ScreenTools.demiboldFontFamily
                    }
                }
            }

            //log
            Rectangle{
                id:                     logView
                color:                  Qt.rgba(0,0,0,0.40)
                visible:                true
                border.width:           1
                radius:                 10
                //width:                  multiVideoWindow.width/2-10
                //height:                 multiVideoWindow.height/2-10
                anchors.left:           dataSpace.left
                anchors.top:            swipeView.bottom
                anchors.bottom:         dataSpace.bottom
                anchors.right:          dataSpace.right
                anchors.leftMargin:     5
                anchors.topMargin:      5
                anchors.bottomMargin:   5
                anchors.rightMargin:    5


                QGCTextField{
                    id:             textFieldMain
                    anchors.top:    logView.top
                    anchors.bottom: logView.bottom
                    anchors.left:   logView.left
                    anchors.right: logView.right
                    anchors.leftMargin:     5
                    anchors.topMargin:      5
                    anchors.bottomMargin:   5
                    anchors.rightMargin:    5
                }
            }






            Connections {
                target: QGroundControl.customProtocol

                onPod1UpdatedData: {
                    pod1Data.updateFields(strList);
                }

                onPod2UpdatedData: {
                    pod2Data.updateFields(strList);
                }

            }
        }
    }
}
