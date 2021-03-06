import QtQuick 2.12
import QtQuick.Controls 1.2 as QQC1
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Private 1.0 as QQCP
import QtQuick.Controls.Styles 1.1
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


QQC2.Control {
    id: control

    property var videoObjects: [];
    property var audioObjects: [];
    property alias from: rangeModel.minimumValue;
    property alias to: rangeModel.maximumValue;
    property alias stepSize: rangeModel.stepSize;
    property alias value: rangeModel.value;
    property color color: '#89C4F4';
    property color backgroundColor: 'gray';

    property alias pressed: mouseArea.pressed
    //property alias hovered: mouseArea.containsMouse

    height: 15
    opacity: enabled ? 1: 0.5;

    background:
        Rectangle {
            color: control.backgroundColor
            border.color: '#eee'
            radius: 2

            clip: true
        }

    contentItem:
        Item {
            Column {
                Item {
                    id: videoVisulizer

                    width: control.width
                    height: control.height / 2
                    clip: true
                }

                Item {
                    id: audioVisulizer

                    width: control.width
                    height: control.height / 2
                    clip: true
                }
            }

            Rectangle {
                height: control.height
                width: rangeModel.position
                radius: 2
                color: control.color
                opacity: 0.7
            }
        }

    Rectangle {
        x: rangeModel.position - width/2;
        width: mouseArea.pressed ? 3 : 1;
        height: control.height
        opacity: 0.8
        color: "#1b8ee6"
        anchors.verticalCenter: control.verticalCenter;

        Behavior on width {
            NumberAnimation {duration: 100;}
        }
    }

    QQCP.RangeModel {
        id: rangeModel
        minimumValue: 0.0;
        maximumValue: 1.0;
        positionAtMinimum: 0;
        positionAtMaximum: control.width;
        stepSize: 0.001;
        value: 0;
    }

    MouseArea {
        id: mouseArea
        anchors.fill: control

        onMouseXChanged: {
            if(mouseArea.pressed) {
                rangeModel.position = mouseX
            }
        }
    }

     function reset() {
         for(var v of videoObjects)
             v.destroy();
         for(var a of audioObjects)
             a.destroy();
         videoObjects = [];
         audioObjects = [];
         value = 0;
     }

    function addVideoSubSection(from, to) {
        var component = Qt.createComponent("Section.qml");
        var sec = component.createObject(videoVisulizer);
        sec.height = videoVisulizer.height;
        videoObjects.push(initSubSection(sec,from, to));
    }

    function addAudioSubSection(from, to) {
        var component = Qt.createComponent("Section.qml");
        var sec = component.createObject(audioVisulizer);
        sec.height = audioVisulizer.height;
        audioObjects.push(initSubSection(sec,from, to));
    }

    function initSubSection(sec,from, to) {
        sec.from = from;
        sec.to = to;
        sec.x = Qt.binding(() => {return from * control.width});
        sec.width = Qt.binding(() => {return (to - from) * control.width;});
        sec.value = Qt.binding(() => {return control.value;});
        sec.color = '#fff';
        return sec;
    }
}
