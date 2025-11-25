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

    private MESManager _currentUser;
    public bool IsShowed { get; private set; } = false;

    private Action _resume;
    private Action _clearPlayers;
    public GameObject FirstSelection { get { return _firstSelection; } }
    public override Menus MenuType()
    {
        return Menus.PauseMenu;
    }

    public void Show(Action resumeAction, Action deletePlayers, string message, Color playerColor, MESManager user)
    {
        _resume = resumeAction;
        IsShowed = true;
        _playerID.color = playerColor;
        _playerID.text = message;
        _currentUser = user;
        _clearPlayers = deletePlayers;
    }

    public void Resume()
    {
        _resume?.Invoke();
        _manager.HideDialog(MenuType());
        IsShowed = false;
    }

    public void ReturnMenu()
    {
        _manager.HideDialog(MenuType());
        var dialog = _manager.ShowDialog(Menus.ConfirmationDialog);
        if (dialog is ConfirmationDialog confirmation)
        {
            confirmation.Show(_playerID.text, _playerID.color, "Are you sure you want to back to Menu?",
                "The progress of current match will be lost.",
                "Back Menu",
                "Continue match", BackMenu, _currentUser);
        }
    }
    public void QuitGame()
    {
        _manager.HideDialog(MenuType());
        var dialog = _manager.ShowDialog(Menus.ConfirmationDialog);
        if (dialog is ConfirmationDialog confirmation)
        {
            confirmation.Show(_playerID.text, _playerID.color, "Are you sure you want to quit the game?",
                "The progress of current match will be lost.",
                "Exit game",
                "Continue match", TerminateApp, _currentUser);
        }
    }

    void TerminateApp()
    {
        _currentUser = null;
        LevelsManager.Instance.QuitGame();
    }

    void BackMenu()
    {
        _currentUser = null;
        _clearPlayers?.Invoke();
        LevelsManager.Instance.ChangeScene(_menuLvl);
    }
}
