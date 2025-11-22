using UnityEngine;

public class LandMenuDialog : DialogBase
{
    public override Menus MenuType()
    {
        return Menus.MainMenu;
    }

    /*public void Show()
    {

    }*/

    public void PlayersSelection()
    {
        _manager.ShowDialog(Menus.PlayerSelection); 
    }
    public void OpenSettings()
    {
        _manager.ShowDialog(Menus.Settings);
    }

    public void QuitGame()
    {
        /*var dialog = _manager.ShowDialog(Menus.ConfirmationDialog);
        if (dialog is ConfirmationDialog confirmation)
        {
            _manager.HideDialog(MenuType());
            confirmation.Show("Are you sure you want to quit the game?",
                "",
                "Quit",
                "Cancel", TerminateGame);
        }*/
    }

    void TerminateGame()
    {
        LevelsManager.Instance.QuitGame();
    }

}
