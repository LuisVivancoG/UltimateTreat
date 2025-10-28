using UnityEngine;

public class RoundTracker : MonoBehaviour
{
    private PlayerController _player;
    public PlayerController Controller { get { return _player; } }
    public int VictoryRounds { get; private set; }
    public int _playerInt { get; private set; }

    //Restart players initial stats (health, material status, rumble)
    //Track number of rounds won

    public void SetPlayer(PlayerController component, int number)
    {
        _player = component;
        _playerInt = number;

        gameObject.name = new string ("Player" + number);
    }

    public void RestoreStats()
    {
        Controller.CharacterGO.SetActive(true);
        _player.RestoreStats();
    }

    public void IncrementVictoryCount()
    {
        VictoryRounds++;
    }
}
