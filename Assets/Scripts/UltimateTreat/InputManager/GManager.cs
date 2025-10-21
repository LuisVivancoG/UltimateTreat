using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GManager : MonoBehaviour
{
    [Header("Current players")]
    [SerializeField] private int _currentPlayers;
    [SerializeField] private TempPlayer _prefab;

    [Header("Win condition")]
    [SerializeField] private int _maxPoints; //Rounds necessary to win match
    [SerializeField] private string _nextScene;

    [Header("Scoreboard settings")]
    [SerializeField] private float _timeScoresDisplayed;
    [SerializeField] private float _timeToStartRound;
    [SerializeField] private float _timeToEndRound;

    private List<RoundTracker> _activePlayers = new List<RoundTracker>();
    private RoundTracker _roundWinner;
    private RoundTracker _gameWinner;

    private void Start()
    {
        SpawnPlayers();
    }

    void SpawnPlayers()
    {
        for (int i = 0; i < _currentPlayers; i++)
        {
            var player = Instantiate(_prefab);
            var tracker = player.AddComponent<RoundTracker>();
            //tracker.SetPlayer(player, i);
            _activePlayers.Add(tracker);
        }

        StartCoroutine(GameLoop());
    }

    private void Update()
    {
        if (Input.anyKeyDown)
        {
            int randomPlayer = Random.Range(0, _activePlayers.Count);
            _activePlayers[randomPlayer].gameObject.SetActive(false);
        }
    }

    IEnumerator GameLoop()
    {
        yield return StartCoroutine(DisplayScores());

        yield return StartCoroutine(RoundStarting());

        yield return StartCoroutine(RoundPlaying());

        yield return StartCoroutine(RoundEnding());

        if (_gameWinner != null)
        {
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
        }
        yield return new WaitForSeconds(_timeScoresDisplayed);
    }

    IEnumerator RoundStarting()
    {
        Debug.LogWarning("Setting players");
        //Clear items on scene
        SetUpPlayers();
        yield return new WaitForSeconds(_timeToStartRound);
    }

    private void SetUpPlayers()
    {
        foreach (var player in _activePlayers)
        {
            player.RestoreStats();
            //Set position within boundaries
        }
    }

    IEnumerator RoundPlaying()
    {
        Debug.LogWarning("Battle started");
        while (!OnePlayerLeft())
        {
            yield return null;
        }
        Debug.LogWarning("No more players");
    }
    IEnumerator RoundEnding()
    {
        _roundWinner = null;
        _roundWinner = GetRoundWinner();

        if (_roundWinner != null)
        {
            _roundWinner.IncrementVictoryCount();
            Debug.Log($"Round winner {_roundWinner.name}");
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
