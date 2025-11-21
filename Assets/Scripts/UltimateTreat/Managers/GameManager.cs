using System.Collections;
using System.Collections.Generic;
using Unity.Cinemachine;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameManager : Singleton<GameManager>
{
    [Header("Players")]
    [SerializeField] private float _initialHP;

    [Header("Win condition")]
    [SerializeField] private int _maxPoints; //Rounds necessary to win match
    [SerializeField] private string _nextScene;

    [Header("Scoreboard settings")]
    [SerializeField] private float _timeScoresDisplayed;
    [SerializeField] private float _timeToStartRound;
    [SerializeField] private float _timeToEndRound;

    [Header("Misc")]
    [SerializeField] private LevelsManager _levelsManager;
    [SerializeField] private CinemachineTargetGroup _targetGroup;
    [SerializeField] private CratesManager _spawnerManager;
    [SerializeField] private PlayerInputManager _inputManager;

    private List<RoundTracker> _activePlayers = new List<RoundTracker>();
    private RoundTracker _roundWinner;
    private RoundTracker _gameWinner;

    private ScoreboardDialog _matchBoard;

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
        }
        StartCoroutine(InitiateCrates());
        FetchPlayers();

        StartCoroutine(GameLoop());
    }

    IEnumerator InitiateCrates()
    {
        yield return new WaitForSeconds(7f);
        _spawnerManager.SpawnCrates();
    }

    void FetchPlayers()
    {
        var created = UIManager.Instance.ShowDialog(Menus.Scoreboard);
        if (created is ScoreboardDialog scoreboard)
        {
            int iD = 1;

            PlayerController[] players = FindObjectsByType<PlayerController>(FindObjectsSortMode.None);
            foreach (var player in players)
            {
                //Debug.LogError($"{player.gameObject.name}");
                player.SetUp(iD, _initialHP);

                var tracker = player.AddComponent<RoundTracker>();

                _activePlayers.Add(tracker);

                tracker.SetPlayer(player);
                var playerI = scoreboard.AddPlayerToBoard(tracker, iD, tracker.Controller.PlayerColor);
                tracker.SetTracker(playerI);
                iD++;

                _targetGroup.AddMember(player.CharacterGO.transform, 0, 1);
            }
        }
        UIManager.Instance.HideDialog(Menus.Scoreboard);
    }

    public void SetScoreboard(ScoreboardDialog currentBoard)
    {
        _matchBoard = currentBoard;
    }

    IEnumerator GameLoop()
    {
        yield return StartCoroutine(DisplayScores());

        yield return StartCoroutine(RoundStarting());

        yield return StartCoroutine(RoundPlaying());

        yield return StartCoroutine(RoundEnding());

        if (_gameWinner != null)
        {
            //yield return StartCoroutine(DisplayScores());
            StartCoroutine(VictorySequence());
        }
        else
        {
            StartCoroutine(GameLoop());
        }
    }

    IEnumerator DisplayScores()
    {
        foreach (var player in _activePlayers)
        {
            player.Controller.SetInputActiveState(true);
        }

        UIManager.Instance.ShowDialog(Menus.Scoreboard);
        yield return new WaitForSeconds(_timeScoresDisplayed);
        UIManager.Instance.HideDialog(Menus.Scoreboard);

        foreach (var player in _activePlayers)
        {
            player.Controller.SetInputActiveState(false);
        }
    }

    IEnumerator RoundStarting()
    {
        //Clear items on scene
        SetUpPlayers();
        yield return new WaitForSeconds(_timeToStartRound);
    }

    private void SetUpPlayers()
    {
        foreach (var player in _activePlayers)
        {
            player.RestoreStats();
            player.Controller.CharacterGO.transform.position = _spawnerManager.GetLocationInBoundBox();

            int index = _targetGroup.FindMember(player.Controller.CharacterGO.transform);
            _targetGroup.Targets[index].Weight = 1;
        }
    }

    IEnumerator RoundPlaying()
    {
        while (!OnePlayerLeft())
        {
            yield return null;
        }
    }
    IEnumerator RoundEnding()
    {
        _roundWinner = null;
        _roundWinner = GetRoundWinner();

        if (_roundWinner != null)
        {
            _roundWinner.IncrementVictoryCount();
        }

        _gameWinner = GetGameWinner();
        yield return new WaitForSeconds(_timeToEndRound);
    }

    bool OnePlayerLeft()
    {
        int playersLeft = 0;

        for (int i = 0; i < _activePlayers.Count; i++)
        {
            if (_activePlayers[i].Controller.CharacterGO.activeSelf)
            {
                playersLeft++;
            }
        }

        return playersLeft <= 1;
    }

    RoundTracker GetRoundWinner()
    {
        for (int i = 0; i < _activePlayers.Count; i++)
        {
            if (_activePlayers[i].Controller.CharacterGO.activeSelf)
            {
                return _activePlayers[i].GetComponent<RoundTracker>();
            }
        }
        return null;
    }

    RoundTracker GetGameWinner()
    {
        for (int i = 0; i < _activePlayers.Count; i++)
        {
            if (_activePlayers[i].VictoryRounds >= _maxPoints)
                return _activePlayers[i];
        }

        return null;
    }

    IEnumerator VictorySequence()
    {
        yield return new WaitForSeconds(6f);

        ShowCredits();
    }

    void ShowCredits()
    {
        foreach (var player in _activePlayers)
        {
            Destroy(player.gameObject);
        }
        LevelsManager.Instance.ChangeScene(_nextScene);
    }

    public void TogglePause(MESManager callerManager, PlayerController caller)
    {
        string textDisplayer;

        var dialog = UIManager.Instance.ShowDialog(Menus.PauseMenu);
        if (dialog is PauseDialog pause)
        {
            pause.Show(RestoreControls, textDisplayer = ($"Pause player {caller.PlayerID}"), caller.PlayerColor);
            SoundManager.Instance.PauseMixer();

            foreach (var player in _activePlayers)
            {
                player.Controller.EnablePauseMenuControls();
            }

            callerManager.UpdateCurrentSelection(pause.FirstSelection);
        }
    }
    void RestoreControls()
    {
        foreach (var player in _activePlayers)
        {
            player.Controller.EnableGameplayControls();
        }
        SoundManager.Instance.UnpauseMixer();
    }
}
