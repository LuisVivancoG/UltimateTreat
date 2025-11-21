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
        //_playerID = iD;
        _maxHealthPoints = maxHP;
        CurrentHealthPoints = _maxHealthPoints;
        IsDead = false;

        //Debug.Log($"Player{_playerID} HP is {CurrentHealthPoints}");
    }

    public void Heal(float heal)
    {
        if (!IsDead)
        {
            CurrentHealthPoints = CurrentHealthPoints + heal;
            CurrentHealthPoints = Mathf.Clamp(CurrentHealthPoints, 0, _maxHealthPoints);
            OnDamageTaken?.Invoke();
        }

        //Debug.Log($"Player{_playerID} HP is {CurrentHealthPoints}");
        //_playerVisuals?.FlashMaterial();
    }

    public void TakeDamage(float damage)
    {
        if (_isVulnerable)
        {
            //CameraShakeManager.Instance.AddShake(.5f, .3f, .25f);
            _isVulnerable = false;

            OnDamageTaken?.Invoke();
            //RumbleManager.Instance.RumblePulse(0.15f, 0.15f, Gamepad.current);

            _snSComp.CheckForAndStartCoroutine();

            CurrentHealthPoints = CurrentHealthPoints - damage;
            CurrentHealthPoints = Mathf.Clamp(CurrentHealthPoints, 0, _maxHealthPoints);

            HealthCheck();

            //Debug.Log($"Player{_playerID} HP is {CurrentHealthPoints}");

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
        //RumbleManager.Instance.StopAllMotions(Gamepad.current);
        //CameraShakeManager.Instance.AddShake(1f, 1f, .5f);
        IsDead = true;
        //AudioManager.PlaySound(TypeOfSound.Death);
        //gameObject.SetActive(false);
        OnDeath?.Invoke();
    }

    void OneHit()
    {
        //RumbleManager.Instance.RumbleConstant(0.05f, 1f, Gamepad.current);
        OnLastHP?.Invoke();
    }

    IEnumerator ExitVulnerability()
    {
        yield return new WaitForSeconds(2);
        _isVulnerable = true;
    }
}
