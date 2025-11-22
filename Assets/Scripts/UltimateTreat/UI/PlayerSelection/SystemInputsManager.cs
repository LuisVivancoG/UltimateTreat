using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class SystemInputsManager : MonoBehaviour
{
    [SerializeField] private GameObject _playersGrp;
    [SerializeField] private GameObject _inputsGrp;

    private List<PlayerInput> _players = new List<PlayerInput>();
    private int _playersCount = 2;

    //Getters
    public int PlayersCount {  get { return _playersCount; } }
    public List<PlayerInput> Players { get { return _players; } }

    public GameObject PlayersGrp { get { return _playersGrp; } }

    public void OnplayerJoined(PlayerInput playerInput)
    {
        /*Debug.Log($"Initial scale {playerInput.gameObject.transform.localScale}" +
            $"Initial position {playerInput.gameObject.transform.localPosition}");*/

        _playersCount++;
    }
}
