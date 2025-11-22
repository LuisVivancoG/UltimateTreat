using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DialogBase : MonoBehaviour
{
    public Canvas DialogCanvas;
    protected UIManager _manager;
    private LevelsManager _levelsManager;
    public virtual Menus MenuType()
    {
        return Menus.Underfined;
    }

    public void OnCreation(UIManager manager, LevelsManager lManager)
    {
        _manager = manager;
        _levelsManager = lManager;
    }
}
