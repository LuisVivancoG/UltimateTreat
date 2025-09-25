using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;

public class GameManagerOld : MonoBehaviour
{
    [SerializeField] private PlayerManager _playerPrefab;
    [SerializeField] private int _victoryRoundsSet;
    [Range(2, 10)]
    [SerializeField] private int TotalPlayers;
    [SerializeField] private List<GameObject> _spawnPoints;
    [SerializeField] private float _initialWaitingTime;
    [SerializeField] private float _endWaitingTime;

    [SerializeField] private PoolsManager _poolsManager;
    [SerializeField] private MisteryBoxManager _misteryBoxManager;
    [SerializeField] private CameraController _cameraManager;

    private PlayerManager _roundWinner;
    private PlayerManager _gameWinner;
    private List<PlayerManager> _activePlayers;

    private WaitForSeconds _startWait;
    private WaitForSeconds _endWait;

    private void Awake()
    {
        int retrievePlayers = PlayerPrefs.GetInt("RequestedPlayers", 2);
        TotalPlayers = retrievePlayers;

        UnityEngine.Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false;

        _startWait = new WaitForSeconds(_initialWaitingTime);
        _endWait = new WaitForSeconds(_endWaitingTime);
    }
    void Start()
    {
        SetUp();
    }

    private void SetUp()
    {
        _poolsManager.InitializePool();
        SpawnPlayers();
        _misteryBoxManager.SetUp(_poolsManager);
        SetCameraTargets();

        StartCoroutine(GameLoop());
    }

    private void SpawnPlayers()
    {
        _activePlayers = new List<PlayerManager>();
        for (int i = 0; i < TotalPlayers; i++)
        {
            var newPlayer = Instantiate(_playerPrefab);
            _activePlayers.Add(newPlayer);
            newPlayer.SetUpPlayer(i, _poolsManager);
        }
    }

    void SetCameraTargets()
    {
        for (int i = 0; i < _activePlayers.Count; i++)
        {
            _cameraManager.SetPlayerTarget(_activePlayers[i].gameObject);
        }
    }

    private void SetPlayersPosition()
    {
        foreach (var player in _activePlayers)
        {
            player.RestartPlayerStats();

            int loc = UnityEngine.Random.Range(0, _spawnPoints.Count);
            var randomPos = _spawnPoints[loc].transform.position;

            player.transform.position = randomPos;
        }
    }

    IEnumerator GameLoop()
    {
        yield return StartCoroutine(RoundStarting());

        yield return StartCoroutine(RoundPlaying());

        yield return StartCoroutine(RoundEnding());

        if (_gameWinner != null)
        {
            PlayerPrefs.SetInt("RequestedPlayers", 2);
            PlayerPrefs.Save();
            SceneManager.LoadScene("HomeScreen");
        }
        else
        {
            StartCoroutine(GameLoop());
        }
    }

    IEnumerator RoundStarting()
    {
        SetPlayersPosition();

        yield return _startWait;
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
            _roundWinner.UpdateRoundsVictoryCount();
        }

        _gameWinner = GetGameWinner();
        AudioManager.PlaySound(TypeOfSound.Victory);
        yield return _endWait;
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

    PlayerManager GetRoundWinner()
    {
        for (int i = 0; i < _activePlayers.Count; i++)
        {
            if (_activePlayers[i].gameObject.activeSelf)
            {
                return _activePlayers[i].GetComponent<PlayerManager>();
            }
        }
        return null;
    }

    PlayerManager GetGameWinner()
    {
        for (int i = 0; i < _activePlayers.Count; i++)
        {
            if (_activePlayers[i]._roundsWin == _victoryRoundsSet)
                return _activePlayers[i];
        }

        return null;
    }
}
