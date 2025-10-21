using NUnit.Framework;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayersManager : MonoBehaviour
{
    [SerializeField] private int _playersCount = 2; //Replace with int from SystemInputManager
    //private List<PlayerInput> _currentList = new List<PlayerInput>(); //Replace it with SystemInputManager
    //private List<Color> _colorList = new List<Color>(); //Replace with colors picked

    private GameManager _gameManager;

    private void Start()
    {
        _gameManager = FindAnyObjectByType<GameManager>();

        var input = gameObject.AddComponent<PlayerInput>();
    }

}
