using System.Collections;
using System.Collections.Generic;
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
    //private EventSystem _system;

    [SerializeField] private LevelsManager _levelsManager;
    [SerializeField] private GameObject _displayGrp;
    private PlayerInputManager _inputManager;
    private List<PlayerInput> _playersList;//Make function to update current selection when changing screens for each player on list
                                           //Add each player when added OnStart to players list
                                           //Make sure only first player on top gets control of menus
                                           //Consider instead of list, use stack for players

    public GameObject InitialSelection {  get { return _fButtonLand; } set { _fButtonSelection = value; } }
    public GameObject DisplayGrp {  get { return _displayGrp; } }

    private void Awake()
    {
        //_system = FindAnyObjectByType<EventSystem>();

        _landUI.SetActive(true);
        _selectionUI.SetActive(false);
        //_currentSelection = _fButtonLand;
        //StartCoroutine(CurrentSelectionDelay(_fButtonLand));
    }

    private void Start()
    {
        var levelsManager = FindAnyObjectByType(typeof(LevelsManager));
        if (levelsManager == null)
        {
            Instantiate(_levelsManager);
        }
    }

    public void PlayersSelection()
    {
        _landUI.SetActive(false);
        _selectionUI.SetActive(true);
        //StartCoroutine(CurrentSelectionDelay(_fButtonSelection));
    }

    public void LandMenu()
    {
        _selectionUI.SetActive(false);
        _landUI.SetActive(true);
        //StartCoroutine(CurrentSelectionDelay(_fButtonLand));
    }

    public void TransitionToMatch()
    {
        LevelsManager.Instance.ChangeScene(_nextScene);
    }

    public void TerminateGame()
    {
        LevelsManager.Instance.QuitGame();
    }

    IEnumerator CurrentSelectionDelay(GameObject selection)
    {
        yield return new WaitForSeconds(.2f);
        //_currentSelection = selection;
        //_system.SetSelectedGameObject(selection);
    }
}
