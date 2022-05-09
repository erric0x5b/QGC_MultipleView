#include "MultiVideoManager.h"

#include <QQmlContext>
#include <QQmlEngine>
#include <QSettings>
#include <QUrl>
#include <QDir>
#include <QQuickWindow>

#include "GStreamer.h"
#include "GstVideoReceiver.h"
#include "QGCToolbox.h"
#include "QGCCorePlugin.h"
#include "VideoSettings.h"
#include "QGCApplication.h"
#include "VideoManager.h"
#include "SettingsManager.h"

static const char* kFileExtension[VideoReceiver::FILE_FORMAT_MAX - VideoReceiver::FILE_FORMAT_MIN] = {
    "mkv",
    "mov",
    "mp4"
};

MultiVideoManager::MultiVideoManager(QGCApplication* app, QGCToolbox* toolbox, VideoManager* videoManager)
    : QGCTool(app, toolbox)
{
    _videoManager = videoManager;

}

void MultiVideoManager::_setupReceiver(QGCToolbox *toolbox, unsigned int id)
{
    _videoReceiver[id] = toolbox->corePlugin()->createVideoReceiver(this);
    connect(_videoReceiver[id], &VideoReceiver::onStartComplete, this, [this, id](VideoReceiver::STATUS status) {
        if (status == VideoReceiver::STATUS_OK) {
           qCDebug(VideoManagerLog) << "Started";
           if (_videoSink[id] != nullptr) {
                _videoReceiver[id]->startDecoding(_videoSink[id]);
                qCDebug(VideoManagerLog) << "Decoding";
           }
       } else if (status == VideoReceiver::STATUS_INVALID_URL) {
           // Invalid URL
       } else if (status == VideoReceiver::STATUS_INVALID_STATE) {
           // Already running
       } else {
           // Restart the video (TODO)
       }
    });
    connect(_videoReceiver[id], &VideoReceiver::decodingChanged, this, [this, id](bool active){
        _hasVideo[id] = active;
        qCDebug(VideoManagerLog) << "Video Reciever " << id  << " : " << active;
        // FIXME: Hacky way of emitting the decoding changed event
        switch (id) {
        case 0:
            emit _videoManager->decodingChanged0();
            break;
        case 1:
            emit _videoManager->decodingChanged1();
            break;
        case 2:
            emit _videoManager->decodingChanged2();
            break;
        }
    });
}

void MultiVideoManager::_startReceiver(unsigned int id)
{
    if (_videoReceiver[id] != nullptr) {
        if (!_videoUri[id].isEmpty()) {
            _videoReceiver[id]->start(_videoUri[id], 1000, 0);
        }
    }
}

void MultiVideoManager::_stopReceiver(unsigned int id) {
    if (_videoReceiver[id] != nullptr) {
        if (!_videoUri[id].isEmpty()) {
            _videoReceiver[id]->stop();
        }
    }
}

void MultiVideoManager::_updateVideoURI(unsigned int id, QString uri)
{
     _videoUri[id] = uri;
}

void MultiVideoManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);

    // TODO: Make these settings per video instead of per manager (see comment in VideoManager.cc)
    _videoSettings = toolbox->settingsManager()->videoSettings();
    // restart all videos when a port is changed
    // TODO: wrap in array
    connect(_videoSettings->urlVideo1(), &Fact::rawValueChanged, this, &MultiVideoManager::_udpPortChanged);
    connect(_videoSettings->urlVideo2(), &Fact::rawValueChanged, this, &MultiVideoManager::_udpPortChanged);
    connect(_videoSettings->urlVideo3(), &Fact::rawValueChanged, this, &MultiVideoManager::_udpPortChanged);

    for (int i = 0; i < QGC_MULTI_VIDEO_COUNT; i++) {
        _setupReceiver(toolbox, i);
    }
}

void MultiVideoManager::init()
{
    QQuickWindow* root = qgcApp()->multiVideoWindow();

    _updateVideoURI(0, _videoSettings->urlVideo1()->rawValueString());
    _updateVideoURI(1, _videoSettings->urlVideo2()->rawValueString());
    _updateVideoURI(2, _videoSettings->urlVideo3()->rawValueString());

    if (root == nullptr) {
        qCDebug(VideoManagerLog) << "multiVideoWindow() failed. No multi-video window";
        return;
    }

    QQuickItem* widget;
    for (int i = 0; i < QGC_MULTI_VIDEO_COUNT; i++) {
        widget = root->findChild<QQuickItem*>(QStringLiteral("videoContent%1").arg(i));
        _videoSink[i] = qgcApp()->toolbox()->corePlugin()->createVideoSink(this, widget);
        _startReceiver(i);
    }
}

void MultiVideoManager::startRecording(const QString &videoFile) {
    // TODO: check if receiver is ready

    const VideoReceiver::FILE_FORMAT fileFormat = static_cast<VideoReceiver::FILE_FORMAT>(_videoSettings->recordingFormat()->rawValue().toInt());

    if(fileFormat < VideoReceiver::FILE_FORMAT_MIN || fileFormat >= VideoReceiver::FILE_FORMAT_MAX) {
        qgcApp()->showAppMessage(tr("Invalid video format defined."));
        return;
    }
    QString ext = kFileExtension[fileFormat - VideoReceiver::FILE_FORMAT_MIN];

    // TODO: clean up old videos

    QString savePath = qgcApp()->toolbox()->settingsManager()->appSettings()->videoSavePath();

    if (savePath.isEmpty()) {
        qgcApp()->showAppMessage(tr("Unabled to record video. Video save path must be specified in Settings."));
        return;
    }

    // TODO: check for videoStarted

    for (int i = 0; i < QGC_MULTI_VIDEO_COUNT; i++) {
        if (!_hasVideo[i]) {
            qCDebug(VideoManagerLog) << "Does not have video";
            continue;
        }
        QString _videoFile = savePath + "/"
                + (videoFile.isEmpty() ? QDateTime::currentDateTime().toString("yyyy-MM-dd_hh.mm.ss") : videoFile);
        QDir dir(QStringLiteral("%1").arg(_videoFile));
        if (!dir.exists())
            dir.mkpath(".");
        _videoFile = QStringLiteral("%1/CAM%2").arg(_videoFile).arg(i) + ".";
        qCDebug(VideoManagerLog) << "Video File: " << _videoFile;
        _videoFile += ext;
        _videoReceiver[i]->startRecording(_videoFile, fileFormat);
    }
}

void MultiVideoManager::stopRecording() {
    for (int i = 0; i < QGC_MULTI_VIDEO_COUNT; i++) {
        _videoReceiver[i]->stopRecording();
    }
}

void MultiVideoManager::_restartVideo(unsigned int id) {
    _stopReceiver(id);
    _startReceiver(id);
}

void MultiVideoManager::_udpPortChanged() {
    _updateVideoURI(0, _videoSettings->urlVideo1()->rawValueString());
    _updateVideoURI(1, _videoSettings->urlVideo2()->rawValueString());
    _updateVideoURI(2, _videoSettings->urlVideo3()->rawValueString());
    for (int i = 0; i < QGC_MULTI_VIDEO_COUNT; i++) {
        _restartVideo(i);
    }
}
