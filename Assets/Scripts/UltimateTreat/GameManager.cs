using UnityEngine;

public class GameManager : Singleton<GameManager>
{
    [SerializeField] private PlayerController[] _currentPlayers;

    private void Start()
    {
        SetUpPlayers();
    }

    void SetUpPlayers()
    {
        int tempID = 0;

        foreach (var player in _currentPlayers)
        {
            tempID++;

            player.SetUpPlayer(tempID);
            player._playerHealth.SetHP(tempID, 200);
        }
        //SetPlayersHealth();
    }

    /*void SetPlayersHealth()
    {
        foreach (var player in _currentPlayers)
        {
            player._playerHealth.SetHP(200);
        }
    }*/
}
