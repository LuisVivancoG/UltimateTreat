using DG.Tweening;
using System.Collections;
using UnityEngine;
using UnityEngine.Events;

public class HealthSystem : MonoBehaviour
{
    [SerializeField] private MeshRenderer _renderer;
    [SerializeField] private float _flashDuration;
    [SerializeField] private int _numberOfFlashes;
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
}
