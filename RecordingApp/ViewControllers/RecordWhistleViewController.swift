//
//  RecordWhistleViewController.swift
//  RecordingApp
//
//  Created by Omar Yousef on 2021-10-31.
//

import UIKit
import AVFoundation

class RecordWhistleViewController: UIViewController, AVAudioRecorderDelegate {
    /*
        MARK: Audio Properties
     */
    var recordingSession: AVAudioSession!
    var whistleRecorder: AVAudioRecorder!
    
    /*
        MARK: Layout Properties
     */
    var recordButton: UIButton!//We will use this button to record the user's audio
    var playButton: UIButton! //This audio will play the sound when its finished
    var whistlePlayer: AVAudioPlayer!
    var stackView: UIStackView!//This will be placed inside of the view
    
    

    /*
     MARK: View Methods
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        //Adding a title to the view controller
        title = "Record your whistle"
        //Adding a bar button item that will allow us to record
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Record", style: .plain, target: nil, action: nil)

        //Starting a new recording session
        recordingSession = AVAudioSession.sharedInstance()

        do {
            //Setting the recording category
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            //Activating the recording task
            try recordingSession.setActive(true)
            
            //Request permission from the user to acces the microphone
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //If the user allowed us to access the microphone
                        self.loadRecordingUI()
                    } else {
                        //If the user denied our access
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            //In case the operation failed
            self.loadFailUI()
        }
    }
    
    override func loadView() {
        //Creating a view
        view = UIView()

        //Setting the view's bg to gray
        view.backgroundColor = UIColor.gray

        /*
            Creating a stack view and adding custom styles to it
         */
        stackView = UIStackView()
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        
        //Adding our stackView to the view
        view.addSubview(stackView)

        //Adding constraints to our stackView
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    //MARK: Audio Management Methods(Load or Fail)
    /*
     loadRecordingUI()
     This method will manage the recording operation
     */
    func loadRecordingUI() {
        //CReating the button that will allow the user to record when clicking on it
        recordButton = UIButton()
        
        //Button styles
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setTitle("Tap to Record", for: .normal)
        recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        
        //We will handle button click events using the recordTapped method
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        
        //Adding the button to our stackView
        stackView.addArrangedSubview(recordButton)
        
        //Creating our playButton
        playButton = UIButton()
        //Adding styles to our play button
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("Tap to Play", for: .normal)
        playButton.isHidden = true
        playButton.alpha = 0
        playButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        //Adding the play button to the subview
        stackView.addArrangedSubview(playButton)
    }

    /*
     loadFailUI()
     This method will catch the error if the recording operation failed or the user denied giving us access
     */
    func loadFailUI() {
        //This label will display the error message to the user
        let failLabel = UILabel()
        //Changing the styles for the button
        failLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        //Error message
        failLabel.text = "Recording failed: please ensure the app has access to your microphone."
        //the able will have as many lines as we need to fit the text
        failLabel.numberOfLines = 0

        //Adding the label to our stackView
        stackView.addArrangedSubview(failLabel)
    }

    /*
     MARK: Saving Methods
     */
    /*
     getDocumentsDirectory()
     Finding a writable file thats owned by our project to save our recording file
     */
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    /*
     getWhistleURL()
     This will append our new audio file to the directory owned by our project
     */
    class func getWhistleURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("whistle.m4a")
    }
    
    /*
     MARK: Starting & Finishing recording
     */
    /*
     startRecording()
     Start the recording when the user clicks the record button
     */
    func startRecording() {
        //Styling the view's background
        view.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 1)

        //Changing the button's title
        recordButton.setTitle("Tap to Stop", for: .normal)

        //Looking for a path to save the finished recording file
        let audioURL = RecordWhistleViewController.getWhistleURL()
        print(audioURL.absoluteString)

        //Create a settings dictionary describing the format, sample rate, channels and quality.
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            //Using our AVAudioRecorder to call the record method
            whistleRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            whistleRecorder.delegate = self
            whistleRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    /*
     finishRecording(success: Bool)
     Finish the recording when the recording is done and the record button is tapped
     */
    func finishRecording(success: Bool) {
        //Changing the view's background
        view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)

        //Stop the recording using our AVAudioRecorder
        whistleRecorder.stop()
        whistleRecorder = nil

        //If the recording was successful
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            //We want to show and hide that play button when needed, meaning that we show it when recording finished successfully.
            if playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = false
                    self.playButton.alpha = 1
                }
            }
            //Adding a barbutton item
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        } else {
            //If it didnt succeed
            recordButton.setTitle("Tap to Record", for: .normal)

            //Letting the user know that the recording failed
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your whistle; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    /*
     MARK: Actions
     */
    //if the next bar button item got clicked
    @objc func nextTapped() {
        let vc = SelectGenreViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //When the record button gets tapped, we will trigger that method
    @objc func recordTapped() {
        //Start recording if there is no recording operation going
        if whistleRecorder == nil {
            startRecording()
            //hide it if the user taps to re-record.
            if !playButton.isHidden {
                UIView.animate(withDuration: 0.35) { [unowned self] in
                    self.playButton.isHidden = true
                    self.playButton.alpha = 0
                }
            }
        } else {
            //otherwise stop recording
            finishRecording(success: true)
        }
    }
    
    //When the player button gets tapped
    @objc func playTapped() {
        let audioURL = RecordWhistleViewController.getWhistleURL()

        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: audioURL)
            whistlePlayer.play()
        } catch {
            let ac = UIAlertController(title: "Playback failed", message: "There was a problem playing your whistle; please try re-recording.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    //This method will keep track of whether we finished recording successfully or not
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
