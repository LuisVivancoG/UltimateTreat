using System.Collections.Generic;
using System.ComponentModel;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerProfile
{
    private int _playerNumber;
}

public class SystemInputsManager : MonoBehaviour
{
    [SerializeField] private GameObject _playersGrp;
    [SerializeField] private GameObject _inputsGrp;

    private List<PlayerInput> _players = new List<PlayerInput>();

    private bool _firstPlayerTagged = false;
    private int _playersCount = 2;
    private int _maxPlayers = 4;

    //Getters
    public int PlayersCount {  get { return _playersCount; } }
    public List<PlayerInput> Players { get { return _players; } }

    public GameObject PlayersGrp { get { return _playersGrp; } }

    public void OnplayerJoined(PlayerInput playerInput)
    {
        /*_players.Add(playerInput);

        if (!_firstPlayerTagged)
        {
            playerInput.TryGetComponent<PlayerDisplay>(out var script);

        }*/

        Debug.Log($"Initial scale {playerInput.gameObject.transform.localScale}" +
            $"Initial position {playerInput.gameObject.transform.localPosition}");

        playerInput.TryGetComponent<PlayerDisplay>(out var component);
        PrefabTransformCheck(component.GOTransform);

        Debug.Log($"Initial scale {component.GOTransform.localScale}" +
            $"Initial position {component.GOTransform.localPosition}");

        _playersCount++;
    }

    void PrefabTransformCheck(RectTransform transform)
    {
        transform.localScale = Vector3.one;
        transform.localPosition = Vector3.zero;
    }

    /*private void Update()
    {
        if(Input.GetKeyUp(KeyCode.A))
        {
            _playersCount++;
            Instantiate(_displayPlayer, _playersGrp.transform);
        }
        if (Input.GetKeyUp(KeyCode.D))
        {
            _playersCount--;
            var player = _playersGrp.transform.GetChild(_playersCount - 1);
            Destroy(player.gameObject);
        }
    }*/
}
