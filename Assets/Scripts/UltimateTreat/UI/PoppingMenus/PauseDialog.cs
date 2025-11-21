using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseDialog : DialogBase
{
    [SerializeField] private string _menuLvl;
    [SerializeField] GameObject _firstSelection;
    [SerializeField] private TextMeshProUGUI _playerID;
    public bool IsShowed { get; private set; } = false;

    private Action _resume;
    public GameObject FirstSelection { get { return _firstSelection; } }
    public override Menus MenuType()
    {
        return Menus.PauseMenu;
    }

    public void Show(Action resumeAction, string message, Color playerColor)
    {
        _resume = resumeAction;
        IsShowed = true;
        _playerID.color = playerColor;
        _playerID.text = message;
    }

    public void Resume()
    {
        _resume?.Invoke();
        _manager.HideDialog(MenuType());
        IsShowed = false;
    }

    public void ReturnMenu()
    {
        var dialog = _manager.ShowDialog(Menus.ConfirmationDialog);
        if (dialog is ConfirmationDialog confirmation)
        {
            _manager.HideDialog(MenuType());
            confirmation.Show("Are you sure you want to back to Menu?",
                "The progress of current match will be lost.",
                "Back Menu",
                "Continue match", BackMenu);
        }
    }
    public void QuitGame()
    {
        var dialog = _manager.ShowDialog(Menus.ConfirmationDialog);
        if (dialog is ConfirmationDialog confirmation)
        {
            _manager.HideDialog(MenuType());
            confirmation.Show("Are you sure you want to quit the game?",
                "The progress of current match will be lost.",
                "Exit game",
                "Continue match", TerminateApp);
        }
    }

    void TerminateApp()
    {
        LevelsManager.Instance.QuitGame();
    }

    void BackMenu()
    {
        LevelsManager.Instance.ChangeScene(_menuLvl);
    }
}
