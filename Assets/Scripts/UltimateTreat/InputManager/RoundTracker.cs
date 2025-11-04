using UnityEngine;

public class RoundTracker : MonoBehaviour
{
    private PlayerController _player;
    private PlayerUITracker _tracker;
    public PlayerController Controller { get { return _player; } }
    public int VictoryRounds { get; private set; }
    //public int PlayerID { get; private set; }

    //Restart players initial stats (health, material status, rumble)
    //Track number of rounds won

    public void SetPlayer(PlayerController component, PlayerUITracker currentUI)
    {
        _player = component;
        _tracker = currentUI;
    }

    public void RestoreStats()
    {
        Controller.CharacterGO.SetActive(true);
        _player.RestoreStats();
    }

    public void IncrementVictoryCount()
    {
        VictoryRounds++;
        _tracker.GrantStar(VictoryRounds);
    }
}
