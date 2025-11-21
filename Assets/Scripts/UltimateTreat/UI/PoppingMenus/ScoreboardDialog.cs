using System;
using UnityEngine;

public class ScoreboardDialog : DialogBase
{
    [SerializeField] private PlayerUITracker _playerUIPrefab;
    [SerializeField] private GameObject _layoutGrp;

    public override Menus MenuType()
    {
        return Menus.Scoreboard;
    }

    private void Start()
    {
        GameManager.Instance.SetScoreboard(this);
    }

    public PlayerUITracker AddPlayerToBoard (RoundTracker currentPlayer, int iD, Color playerColor)
    {
        var playerScore = Instantiate(_playerUIPrefab, _layoutGrp.transform);
        playerScore.SetPlayerData(new string ("P" + iD), currentPlayer.Controller.PlayerColor);

        return playerScore;
        //playerScore.GrantStar = pointCollected;
    }
}
