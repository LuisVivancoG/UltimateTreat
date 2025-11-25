using System.Collections;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

public class HealthSystem : MonoBehaviour
{
    [Header ("Flash effect")]
    [SerializeField] private float _lowHPMark;
    public UnityEvent OnDamageTaken;
    public UnityEvent OnLastHP;

    private int _playerID;
    private float _maxHealthPoints;
    private bool _isVulnerable;
    private SquashAndStretch _snSComp;
    public bool IsDead { get; private set; }
    public float CurrentHealthPoints { get; private set; }

    [SerializeField] private CinemachineImpulseSource _impulseSource;

    public UnityEvent OnDeath;

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
    }

    public void SetHP(float maxHP)
    {
        _maxHealthPoints = maxHP;
        CurrentHealthPoints = _maxHealthPoints;
        IsDead = false;
    }

    public void Heal(float heal)
    {
        if (!IsDead)
        {
            CurrentHealthPoints = CurrentHealthPoints + heal;
            CurrentHealthPoints = Mathf.Clamp(CurrentHealthPoints, 0, _maxHealthPoints);
            OnDamageTaken?.Invoke();
        }
    }

    public void TakeDamage(float damage)
    {
        if (_isVulnerable)
        {
            _isVulnerable = false;

            OnDamageTaken?.Invoke();

            _snSComp.CheckForAndStartCoroutine();

            CurrentHealthPoints = CurrentHealthPoints - damage;
            CurrentHealthPoints = Mathf.Clamp(CurrentHealthPoints, 0, _maxHealthPoints);

            HealthCheck();

            StartCoroutine(ExitVulnerability()); 
        }
    }

    void HealthCheck()
    {
        if(CurrentHealthPoints <= _lowHPMark)
        {
            OneHit();
        }

        if (CurrentHealthPoints <= 0 && !IsDead)
        {
            Death();
        }
    }

    public void Death()
    {
        SoundManager.Instance.Play("Poof");
        PoolsManagment.Instance.GetObject(SOType.KillParticles, transform.position, transform.localEulerAngles);
        _impulseSource.GenerateImpulse(.3f);
        IsDead = true;
        OnDeath?.Invoke();
    }

    void OneHit()
    {
        OnLastHP?.Invoke();
    }

    IEnumerator ExitVulnerability()
    {
        yield return new WaitForSeconds(2);
        _isVulnerable = true;
    }
}
