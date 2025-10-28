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

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
        }

        StartCoroutine(InitiateCrates());
        FetchPlayers();
    }

    IEnumerator InitiateCrates()
    {
        yield return new WaitForSeconds(7f);
        _spawnerManager.SpawnCrates();
    }

    void FetchPlayers()
    {
        int i = 0;

        PlayerController[] players = FindObjectsByType<PlayerController>(FindObjectsSortMode.None);
        foreach (var player in players)
        {
            Debug.Log($"{player.gameObject.name}");
            player.SetUp(i + 1, _initialHP);
            var tracker = player.AddComponent<RoundTracker>();
            tracker.SetPlayer(player, i + 1);
            _activePlayers.Add(tracker);
            i++;
        }

        StartCoroutine(GameLoop());
    }

    IEnumerator GameLoop()
    {
        yield return StartCoroutine(DisplayScores());

        yield return StartCoroutine(RoundStarting());

        yield return StartCoroutine(RoundPlaying());

        yield return StartCoroutine(RoundEnding());

        if (_gameWinner != null)
        {
            yield return StartCoroutine(DisplayScores());
            VictorySequence();
        }
        else
        {
            StartCoroutine(GameLoop());
        }
    }

    IEnumerator DisplayScores()
    {
        Debug.Log($"Current results");
        foreach (var player in _activePlayers)
        {
            Debug.Log($"{player}: {player.VictoryRounds} wins");

            if(player.VictoryRounds == _maxPoints)
            {
                Debug.LogWarning($"{player.name} has won the game");
            }
        }
        yield return new WaitForSeconds(_timeScoresDisplayed);
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
            _targetGroup.AddMember(player.Controller.CharacterGO.transform, 1f, 1f);
            player.Controller.CharacterGO.transform.position = _spawnerManager.GetLocationInBoundBox();
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
            if (_activePlayers[i].gameObject.activeSelf)
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
            if (_activePlayers[i].VictoryRounds == _maxPoints)
                return _activePlayers[i];
        }

        return null;
    }

    void VictorySequence()
    {
        foreach (var player in _activePlayers)
        {
            Destroy(player.gameObject);
        }
        LevelsManager.Instance.ChangeScene(_nextScene);
    }
}
