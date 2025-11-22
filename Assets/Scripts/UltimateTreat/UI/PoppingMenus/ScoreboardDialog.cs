using NUnit.Framework;
using System;
using System.Collections.Generic;
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

    public void RemovePlayers()
    {
        var childs = _layoutGrp.transform.childCount;
        var gOList = new List<GameObject>();

        for (int i = 0; i < childs; i++)
        {
            gOList.Add(_layoutGrp.transform.GetChild(i).gameObject);
        }
        foreach (var child in gOList)
        {
            Destroy(child.gameObject);
        }
    }
}
