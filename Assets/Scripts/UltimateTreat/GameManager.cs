using UnityEngine;

public class GameManager : Singleton<GameManager>
{
    [SerializeField] private PlayerController[] _currentPlayers;

    void SetUpPlayers()
    {
        int tempID = 0;

        foreach (var player in _currentPlayers)
        {
            tempID++;

            player.SetUpPlayer(tempID);
        }
    }
}
