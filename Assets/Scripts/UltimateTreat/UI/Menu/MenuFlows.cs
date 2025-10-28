using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class MenuFlows : MonoBehaviour
{
    [Header("GameplayScene")]
    [SerializeField] private string _nextScene;

    [Header("MenuGroups")]
    [SerializeField] private GameObject _landUI;
    [SerializeField] private GameObject _selectionUI;

    [Header("EventSystem")]
    [SerializeField] private GameObject _fButtonLand;
    [SerializeField] private GameObject _fButtonSelection;
    private GameObject _currentSelection;
    //private EventSystem _system;

    [SerializeField] private LevelsManager _levelsManager;
    [SerializeField] private GameObject _displayGrp;
    //private PlayerInputManager _inputManager;
    private List<MESManager> _playersList;
    private MESManager _playerOne;

    public GameObject InitialSelection {  get { return _fButtonLand; } set { _fButtonSelection = value; } }
    public GameObject DisplayGrp {  get { return _displayGrp; } }

    private void Awake()
    {
        //_system = FindAnyObjectByType<EventSystem>();

        _landUI.SetActive(true);
        _selectionUI.SetActive(false);
        //_currentSelection = _fButtonLand;
        //StartCoroutine(CurrentSelectionDelay(_fButtonLand));
        _playersList = new List<MESManager>();
    }

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
            Debug.Log($"{_levelsManager.gameObject.name}");
        }
        else
        {
            Debug.Log($"{LevelsManager.Instance.gameObject.name}");
        }
    }

    public void AddPlayerToList(MESManager player)
    {
        if (_playerOne == null)
        {
            _playerOne = player;
        }
        _playersList.Add(player);
    }

    public void PlayersSelection()
    {
        _landUI.SetActive(false);
        _selectionUI.SetActive(true);
        StartCoroutine(CurrentSelectionDelay(_fButtonSelection));
    }

    public void LandMenu()
    {
        _selectionUI.SetActive(false);
        _landUI.SetActive(true);
        StartCoroutine(CurrentSelectionDelay(_fButtonLand));
    }

    public void TransitionToMatch(TMP_Text prompt)
    {
        if(_playersList.Count < 2)
        {
            prompt.color = Color.red;
            prompt.text = new string("Not enough players. Plug another device");
        }
        else
        {
            prompt.color = Color.white;
            prompt.text = new string("GET READY!");
            LevelsManager.Instance.ChangeScene(_nextScene);
            foreach (var player in _playersList)
            {
                player.PlayerInput.SwitchCurrentActionMap("Player Controls");
            }
        }
    }

    public void TerminateGame()
    {
        LevelsManager.Instance.QuitGame();
    }

    IEnumerator CurrentSelectionDelay(GameObject selection)
    {
        yield return new WaitForSeconds(.2f);

        _playerOne.UpdateCurrentSelection(selection);
    }
}
