using System.Collections;
using System.Collections.Generic;
//using Unity.AI.Navigation;
using Unity.Cinemachine;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.InputSystem;

public class GameManager : Singleton<GameManager>
{
    [Header("Players")]
    [SerializeField] private int _currentPlayers;
    [SerializeField] private PlayerController _prefab;
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

    //[SerializeField] public List<PlayerController> _currentPlayers;

    //[SerializeField] private NavMeshSurface _levelSruface;

    //[SerializeField] private InputActionReference _actionReference;

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
        }

        StartCoroutine(InitiateCrates());
        SpawnPlayers();
    }

    IEnumerator InitiateCrates()
    {
        yield return new WaitForSeconds(7f);
        _spawnerManager.SpawnCrates();
    }

    void SpawnPlayers()
    {
        for (int i = 0; i < _currentPlayers; i++)
        {
            //var player = Instantiate(_prefab);
            var player = _inputManager.JoinPlayer(i);
            var component = player.GetComponent<PlayerController>();
            component.SetUp(i + 1, _initialHP);
            var tracker = player.AddComponent<RoundTracker>();
            tracker.SetPlayer(component, i + 1);
            _activePlayers.Add(tracker);
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
        //Debug.LogWarning("Setting players");
        //Clear items on scene
        SetUpPlayers();
        yield return new WaitForSeconds(_timeToStartRound);
    }

    private void SetUpPlayers()
    {
        foreach (var player in _activePlayers)
        {
            player.RestoreStats();
            _targetGroup.AddMember(player.gameObject.transform, 1f, 1f);
            player.transform.position = _spawnerManager.GetLocationInBoundBox();
            //Set position within boundaries
        }
    }

    IEnumerator RoundPlaying()
    {
        //Debug.LogWarning("Battle started");
        while (!OnePlayerLeft())
        {
            yield return null;
        }
        //Debug.LogWarning("No more players");
    }
    IEnumerator RoundEnding()
    {
        _roundWinner = null;
        _roundWinner = GetRoundWinner();

        if (_roundWinner != null)
        {
            _roundWinner.IncrementVictoryCount();
            //Debug.Log($"Round winner {_roundWinner.name}");
        }

        _gameWinner = GetGameWinner();
        //AudioManager.PlaySound(TypeOfSound.Victory);
        yield return new WaitForSeconds(_timeToEndRound);
    }

    bool OnePlayerLeft()
    {
        int playersLeft = 0;

        for (int i = 0; i < _activePlayers.Count; i++)
        {
            if (_activePlayers[i].gameObject.activeSelf)
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
        LevelsManager.Instance.ChangeScene(_nextScene);
    }
}
