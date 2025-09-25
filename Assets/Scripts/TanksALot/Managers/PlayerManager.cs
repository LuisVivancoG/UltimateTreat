using TMPro;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{
    [SerializeField] private float _playerMaxHp;
    [SerializeField] private TankMovement _movementController;
    [SerializeField] private TankShooting _turretController;
    [SerializeField] private HealthManager _healthMonitor;
    [SerializeField] private UIManager _uiManager;
    [SerializeField] private TMP_Text _playerTag;

    public int _playerNumber {  get; private set; }
    public int _roundsWin {  get; private set; }

    internal void SetUpPlayer(int i, PoolsManager initializedPool)
    {
        _playerNumber = i;
        _turretController.SetUp(initializedPool, _healthMonitor);
        _healthMonitor.SetHP(_playerMaxHp);
        _playerTag.text = "P"+(_playerNumber+1);

        _uiManager.SetUpSlider(_healthMonitor._currentHealthPoints);
    }
    internal void UpdateRoundsVictoryCount()
    {
        _roundsWin++;
        _uiManager.AddStar(_roundsWin);
    }
    internal void RestartPlayerStats()
    {
        gameObject.SetActive(true);
        _healthMonitor.SetHP(_playerMaxHp);
        _uiManager.SetUpSlider(_healthMonitor._currentHealthPoints);
    }
}
