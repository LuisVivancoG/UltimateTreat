using TMPro;
using UnityEngine;

public class LastBoard : DialogBase
{
    [SerializeField] private TMP_Text _titleTxt;
    //[SerializeField] private TMP_Text _descriptionTxt;
    [SerializeField] private TMP_Text _playerTxt;

    public override Menus MenuType()
    {
        return Menus.FinalBoard;
    }

    public void Show(RoundTracker winner)
    {
        _titleTxt.color = winner.Controller.PlayerColor;

        _playerTxt.color = winner.Controller.PlayerColor;
        _playerTxt.text = $"Player {winner.Controller.PlayerID} WINS!!!";
    }
}
