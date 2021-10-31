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
    
    //A method to silence the error
    @objc func nextTapped() {
        
    }
    
    /*
     MARK: Actions
     */
    //When the record button gets tapped, we will trigger that method
    @objc func recordTapped() {
        //Start recording if there is no recording operation going
        if whistleRecorder == nil {
            startRecording()
        } else {
            //otherwise stop recording
            finishRecording(success: true)
        }
    }
    
    
    //This method will keep track of whether we finished recording successfully or not
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
