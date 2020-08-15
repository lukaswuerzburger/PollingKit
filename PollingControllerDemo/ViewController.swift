//
//  ViewController.swift
//  PollingControllerDemo
//
//  Created by Lukas Würzburger on 8/15/20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit
import PollingController

class ViewController: UIViewController {

    struct State {
        var points: [Float] = []
        var lastPoint: Float? = 0
        var delaySliderValue: Float = 0.1
        var minimumDelay: TimeInterval = 0.1
        var maximumDelay: TimeInterval = 5
        var timerTickSliderValue: Float = 0.2
        var minimumTimerTick: TimeInterval = 1
        var maximumTimerTick: TimeInterval = 5

        var delay: TimeInterval {
            let range = maximumDelay - minimumDelay
            let delay = minimumDelay + TimeInterval(delaySliderValue) * range
            return delay
        }

        var timerTick: TimeInterval {
            let range = maximumTimerTick - minimumTimerTick
            let timerTick = minimumTimerTick + TimeInterval(timerTickSliderValue) * range
            return timerTick
        }
    }

    // MARK: - UI Elements

    @IBOutlet private weak var graphView: GraphView!
    @IBOutlet private weak var delaySlider: UISlider!
    @IBOutlet private weak var minimumDelayLabel: UILabel!
    @IBOutlet private weak var delayLabel: UILabel!
    @IBOutlet private weak var maximumDelayLabel: UILabel!
    @IBOutlet private weak var timerTickSlider: UISlider!
    @IBOutlet private weak var minimumTimerTickLabel: UILabel!
    @IBOutlet private weak var timerTickLabel: UILabel!
    @IBOutlet private weak var maximumTimerTickLabel: UILabel!

    // MARK: - UI Actions

    @IBAction private func startButtonPressed() {
        stopPolling()
        startPolling()
    }

    @IBAction private func stopButtonPressed() {
        stopPolling()
    }

    @IBAction private func delaySliderValueChanged(_ slider: UISlider) {
        state.delaySliderValue = slider.value
    }

    @IBAction private func timerTickSliderValueChanged(_ slider: UISlider) {
        state.timerTickSliderValue = slider.value
        stopPolling()
        startPolling()
    }

    // MARK: - Variables

    private var state = State() {
        didSet { updateView(state: state) }
    }
    private var graphTimer: Timer?
    private var pollingController: PollingController?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraphView()
        updateView(state: state)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupGraphTimer()
    }

    // MARK: - View Setup

    private func setupGraphView() {
        graphView.pointWidth = 3
        graphView.max = 3
    }

    private func updateView(state: State) {
        delaySlider.value = state.delaySliderValue
        timerTickSlider.value = state.timerTickSliderValue
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        minimumDelayLabel.text = numberFormatter.string(from: NSNumber(value: state.minimumDelay))
        maximumDelayLabel.text = numberFormatter.string(from: NSNumber(value: state.maximumDelay))
        delayLabel.text = numberFormatter.string(from: NSNumber(value: state.delay))
        minimumTimerTickLabel.text = numberFormatter.string(from: NSNumber(value: state.minimumTimerTick))
        maximumTimerTickLabel.text = numberFormatter.string(from: NSNumber(value: state.maximumTimerTick))
        timerTickLabel.text = numberFormatter.string(from: NSNumber(value: state.timerTick))
    }

    private func setupGraphTimer() {
        graphTimer = Timer.scheduledTimer(withTimeInterval: 1 / 30, repeats: true) { [weak self] timer in
            self?.handleTimerTick(timer)
        }
    }

    // MARK: - Polling

    private func startPolling() {
        setupPollingController()
        pollingController?.start()
    }

    private func stopPolling() {
        pollingController?.stop()
        pollingController = nil
    }

    private func setupPollingController() {
        pollingController = PollingController(preferredInterval: state.timerTick, handler: { [weak self] callback in
            self?.asyncMethod {
                callback()
            }
        })
        pollingController?.delegate = self
    }

    private func asyncMethod(handler: @escaping () -> Void) {
        let range = state.maximumDelay - state.minimumDelay
        let delay = state.minimumDelay + TimeInterval(state.delaySliderValue) * range
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            handler()
        }
    }

    private func handleTimerTick(_ timer: Timer) {
        var points = state.points
        if CGFloat(points.count) > (graphView.frame.width / graphView.pointWidth) {
            points.removeFirst()
        }
        if let pendingPoint = state.lastPoint {
            points.append(pendingPoint)
        }
        state.points = points
        graphView.points = points
    }
}

extension ViewController: PollingControllerDelegate {

    func pollingController(_ pollingController: PollingController, didChangeState state: PollingController.State) {
        switch state {
        case .idle:
            self.state.lastPoint = 0
        case .waitingForTimerTick:
            self.state.lastPoint = 1
        case .runningWithoutTimer:
            self.state.lastPoint = 2
        case .runningWithTimer:
            self.state.lastPoint = 3
        }
    }
}
