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
                height:                 dataSpace.height/2-10
                anchors.left:           dataSpace.left
                anchors.top:            dataSpace.top
                anchors.topMargin:      5
                anchors.leftMargin:     5


                PODSectionComponent{
                    id: pod1Data;
                    anchors.fill: parent
                    podTitle : qsTr("POD 1")

                    onEnable24VChanged: {
                        QGroundControl.customProtocol.enable24V(1, checkedStatus);
                    }
                    onEnable12VChanged: {
                        QGroundControl.customProtocol.enable12V(1, checkedStatus);
                    }
                    onEnableVMotChanged:{
                         QGroundControl.customProtocol.enableVMot(1, checkedStatus);
                    }
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
                height:                 dataSpace.height/2-10
                anchors.left:           pod1Section.right
                anchors.top:            dataSpace.top
                anchors.leftMargin:     5
                anchors.topMargin:     5

                PODSectionComponent{
                    id: pod2Data;
                    anchors.fill: parent
                    podTitle : qsTr("POD 2")

                    onEnable24VChanged: {
                        QGroundControl.customProtocol.enable24V(2, checkedStatus);
                    }
                    onEnable12VChanged: {
                        QGroundControl.customProtocol.enable12V(2, checkedStatus);
                    }
                    onEnableVMotChanged:{
                         QGroundControl.customProtocol.enableVMot(2, checkedStatus);
                    }
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
                height:                 dataSpace.height/2-10
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
                height:                 multiVideoWindow.height/2-10
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
                anchors.bottom:         dataSpace.bottom
                anchors.leftMargin:     5
                anchors.bottomMargin:   5
            }





            Connections {
                target: QGroundControl.customProtocol

                onPod1UpdatedData: {
                   // pod1Data.updateFields(strList);
                   /* labelVbat1.text = strList[0];
                    labelVmot1.text = strList[1];
                    labelV48v1.text = strList[2];
                    labelIBattv1.text = strList[3];
                    labelTemperaturev1.text = strList[4];
                    labelDigitalIn.text = strList[5];
                    labelVmotIn.text = strList[6];
                    labelLeak.text = strList[7];
                    //dottor.color = Qt.rgba(Math.random(), Math.random(), Math.random(), 1);
                    */
                }
            }
        }
    }
}
