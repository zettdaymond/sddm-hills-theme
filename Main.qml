/***************************************************************************
* Copyright (c) 2015 Zett Daymond <zettday@gmail.com>
* Copyright (c) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0
import QtMultimedia 5.0

Rectangle {
    id: container
    width: 1024
    height: 768

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm
        onLoginSucceeded: {
        }

        onLoginFailed: {
            txtMessage.text = textConstants.loginFailed
            listView.currentItem.password.text = ""
        }
    }

    Repeater {
        model: screenModel
        Background {
            //visible: config.use_video_instead_image === "true" ? false : true
            visible : true
            x: geometry.x; y: geometry.y; width: geometry.width; height:geometry.height
            source: config.background_image
            fillMode: Image.PreserveAspectCrop

                    //TODO: move to repeater instead of "Background"
		    VideoOutput {
		        anchors.fill: parent
		        source: video_path
		        fillMode: VideoOutput.PreserveAspectCrop
		        visible: config.use_video_instead_image === "true" ? true : false

		        MediaPlayer {
		            id: video_path
		            autoLoad: true
		            autoPlay: true
		            loops: Animation.Infinite
		            source: config.use_video_instead_image === "true" ? config.background_video : ""
		        }
		    }
        }        
    }

    Rectangle {
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
        color: "transparent"

        Component {
            id: userDelegate

            ThemePictureBox {
                id: userDelRect
                anchors.verticalCenter: parent.verticalCenter
                name: (model.realName === "") ? model.name : model.realName
                icon: model.icon
                showPassword: model.needsPassword

                focus: (listView.currentIndex === index) ? true : false
                state: (listView.currentIndex === index) ? "active" : ""

                onLogin: sddm.login(model.name, password, sessionIndex);

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index;
                        listView.focus = true;
                    }
                }
            }
        }
        Rectangle {
            width: parent.width / 2; height: parent.height
            color: "transparent"
            clip: true
            anchors.centerIn: parent;

            ThemeClock {
                id: clock
                anchors.horizontalCenter : parent.horizontalCenter
                anchors.bottom : usersContainer.top
                anchors.bottomMargin : 20
                color: "white"
                timeFont.family: "Oxygen"
            }


            Item {
                id: usersContainer
                width: parent.width; height: 300
                anchors.verticalCenter: parent.verticalCenter

                ImageButton {
                    id: prevUser
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    source: "resources/data/angle-left.png"
                    onClicked: listView.decrementCurrentIndex()

                    KeyNavigation.backtab: btnShutdown; KeyNavigation.tab: listView
                }

                Item {
                    id: user_container
                    height: parent.height
                    anchors.left: prevUser.right; anchors.right: nextUser.left
                    anchors.verticalCenter: parent.verticalCenter

                        ListView {
                            property variant geometry: screenModel.geometry(screenModel.primary)

                            id: listView
                            anchors.centerIn: parent
                            height: parent.height
                            width: parent.width > userModel.rowCount() * 150 ? userModel.rowCount() * 150 : parent.width
                            clip: true
                            focus: true

                            spacing: 5

                            model: userModel
                            delegate: userDelegate
                            orientation: ListView.Horizontal
                            currentIndex: userModel.lastIndex

                            KeyNavigation.backtab: prevUser; KeyNavigation.tab: nextUser
                        }
                }

                

                ImageButton {
                    id: nextUser
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    source: "resources/data/angle-right.png"
                    onClicked: listView.incrementCurrentIndex()
                    KeyNavigation.backtab: listView; KeyNavigation.tab: session
                }
            }

            Text {
                id: txtMessage
                anchors.top: usersContainer.bottom;
                anchors.margins: 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                text: textConstants.promptSelectUser

                font.pixelSize: 20
                //BUG:
                style: Text.Outline
            }
        }

        Rectangle {
            id: actionBar
            anchors.top: parent.top;
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width; height: 40
            color: "#35000000"

            Row {
                anchors.left: parent.left
                anchors.margins: 5
                height: parent.height
                spacing: 10

                Text {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    text: textConstants.session
                    font.pixelSize: 18
                    verticalAlignment: Text.AlignVCenter
                    color: "#DEDEDE"

                    style: Text.Outline
                }

                ThemeComboBox {
                    id: session
                    width: 245
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter

                    arrowIcon: "resources/data/angle-down.png"

                    model: sessionModel
                    index: sessionModel.lastIndex

                    font.pixelSize: 18

                    KeyNavigation.tab: layoutBox
                }

                Text {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter

                    text: textConstants.layout
                    font.pixelSize: 18
                    verticalAlignment: Text.AlignVCenter
                    color: "#DEDEDE"

                    style: Text.Outline
                }

                ThemeLayoutBox {
                    id: layoutBox
                    width: 90
                    height: 20
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 18
                    textColor : "white"

                    arrowIcon: "resources/data/angle-down.png"

                    KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
                }
            }

            Row {
                height: parent.height
                anchors.right: parent.right
                anchors.margins: 5
                spacing: 10

                ImageButton {
                    id: btnReboot
                    height: parent.height
                    source: "resources/data/reboot.svg"

                    visible: sddm.canReboot

                    onClicked: sddm.reboot()

                    KeyNavigation.backtab: layoutBox; KeyNavigation.tab: btnShutdown
                }

                ImageButton {
                    id: btnShutdown
                    height: parent.height
                    source: "resources/data/shutdown.svg"

                    visible: sddm.canPowerOff

                    onClicked: sddm.powerOff()

                    KeyNavigation.backtab: btnReboot;
                }
            }
        }
    }
}
