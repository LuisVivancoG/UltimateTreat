using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
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
    private EventSystem _system;

    private void Awake()
    {
        _system = FindAnyObjectByType<EventSystem>();

        _landUI.SetActive(true);
        _selectionUI.SetActive(false);
        StartCoroutine(CurrentSelectionDelay(_fButtonLand));
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
        _system.SetSelectedGameObject(selection);
    }
}
