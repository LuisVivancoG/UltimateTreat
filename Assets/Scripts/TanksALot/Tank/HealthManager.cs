using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class HealthManager : MonoBehaviour
{
    public bool IsDead { get; private set; }
    private float _maxHealthPoints;
    public float _currentHealthPoints { get; private set; }

    public UnityEvent<float> HpChanged;

    private void OnEnable()
    {
        IsDead = false;
    }

    public void DoDamage(float damage)
    {
        _currentHealthPoints = _currentHealthPoints - damage;

        _currentHealthPoints = Mathf.Clamp(_currentHealthPoints, 0, _maxHealthPoints);

        Debug.Log("BANG!!!! Player current hp is:" + _currentHealthPoints);
        if (_currentHealthPoints <= 0 && !IsDead)
        {
            OnDead();
        }
        HpChanged?.Invoke(_currentHealthPoints);
    }
    public void Heal(float heal)
    {
        if(!IsDead)
        {
            _currentHealthPoints = _currentHealthPoints + heal;

            _currentHealthPoints = Mathf.Clamp(_currentHealthPoints, 0, _maxHealthPoints);

            Debug.Log("HEAL!!! Player current hp is:" + _currentHealthPoints);
        }
        HpChanged?.Invoke(_currentHealthPoints);
    }
    void OnDead()
    {
        IsDead = true;
        AudioManager.PlaySound(TypeOfSound.Death);
        gameObject.SetActive(false);
    }

    internal void SetHP(float maxHP)
    {
        _maxHealthPoints = maxHP;
        _currentHealthPoints = _maxHealthPoints;
        IsDead = false;
    }
}
