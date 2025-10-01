using DG.Tweening;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

public class HealthSystem : MonoBehaviour
{
    [Header ("Flash effect")]
    [SerializeField] private MeshRenderer _renderer;
    [SerializeField] private float _flashDuration;
    [SerializeField] private int _numberOfFlashes;

    [Header("Rumble settings")]
    [SerializeField] private float _leftMotor;
    [SerializeField] private float _rightMotor;
    [SerializeField] private float _rumbleDuration;

    private int _playerID;
    private float _maxHealthPoints;
    private bool _isVulnerable;
    private SquashAndStretch _snSComp;
    public bool IsDead { get; private set; }
    public float CurrentHealthPoints { get; private set; }
    public UnityEvent<float> HPChanged;

    private void Start()
    {
        _snSComp = GetComponent<SquashAndStretch>();
    }

    private void OnEnable()
    {
        _isVulnerable = true;
    }

    private void OnDisable()
    {
        StopAllCoroutines();
        if (Gamepad.current != null)
        {
            Gamepad.current.SetMotorSpeeds(0, 0);
        }
    }

    public void SetHP(int iD, float maxHP)
    {
        _playerID = iD;
        _maxHealthPoints = maxHP;
        CurrentHealthPoints = _maxHealthPoints;
        IsDead = false;

        Debug.Log($"Player{_playerID} HP is {CurrentHealthPoints}");
    }

    public void Heal(float heal)
    {
        if (!IsDead)
        {
            CurrentHealthPoints = CurrentHealthPoints + heal;
            CurrentHealthPoints = Mathf.Clamp(CurrentHealthPoints, 0, _maxHealthPoints);
        }

        Debug.Log($"Player{_playerID} HP is {CurrentHealthPoints}");
        HPChanged?.Invoke(CurrentHealthPoints);
    }

    public void TakeDamage(float damage)
    {
        if (_isVulnerable)
        {
            StartCoroutine(RumbleGamepad());

            _isVulnerable = false;
            HitEffect();

            CurrentHealthPoints = CurrentHealthPoints - damage;
            CurrentHealthPoints = Mathf.Clamp(CurrentHealthPoints, 0, _maxHealthPoints);

            HealthCheck();

            Debug.Log($"Player{_playerID} HP is {CurrentHealthPoints}");
            HPChanged?.Invoke(CurrentHealthPoints);
        }
    }

    void HealthCheck()
    {
        if (CurrentHealthPoints <= 0 && !IsDead)
        {
            IsDead = true;
            //AudioManager.PlaySound(TypeOfSound.Death);
            gameObject.SetActive(false);
        }
    }

    void HitEffect()
    {
        _snSComp.CheckForAndStartCoroutine();
        StartCoroutine(FlashRoutine(_numberOfFlashes));
    }

    IEnumerator FlashRoutine(int flashes)
    {
        float singleFlashDuration = _flashDuration / (flashes * 2f);

        for (int i = 0; i < flashes; i++)
        {
            _renderer.material.SetInt("_Flash", 1);
            yield return new WaitForSeconds(singleFlashDuration);
            _renderer.material.SetInt("_Flash", 0);
            yield return new WaitForSeconds(singleFlashDuration);
        }
        _isVulnerable = true;
    }

    IEnumerator RumbleGamepad()
    {
        Gamepad.current.SetMotorSpeeds(_leftMotor, _rightMotor);
        yield return new WaitForSeconds(_rumbleDuration);
        Gamepad.current.SetMotorSpeeds(0, 0);
    }
}
