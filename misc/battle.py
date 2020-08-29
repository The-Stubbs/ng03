# -*- coding: utf-8 -*-

class TBattle:
    
    FRounds
    FPlayers
    FKillList
    FGroupList
    FBattleEnd
    FBattleStart
    FEnemyShipsRemaining

    def AddShips(self, Ownerid, Fleetid, Shipid, Hull, Shield, handling, weapon_ammo, weapon_tracking_speed, weapon_turrets, weapon_damage, Mods, Resistances, Quantity, FireAtWill, Tech):
        P = self.GetPlayer(Ownerid)
        
        P.AddShip(Fleetid, Shipid, Hull, Shield, Handling, weapon_ammo, weapon_tracking_speed, weapon_turrets, weapon_damage, Mods, Resistances, quantity, FireAtWill, Tech)
        
    def BeginFight(self):
        self.FBattleStart = timezone.now()

        self.FRounds = 0

        for player in self.FPlayers:
            player.Init()

        # sort the group list to know who shoot first
        SortList(FGroupList, SortGroupsByFirstShooter)
        
    def NextRound(self, MaxRounds):
        Result = self.CanFight()
        if not Result: return Result

        # rounds
        for R in range(1, MaxRounds):
            self.NewRound()

            AmmoRemaining = False
            while not AmmoRemaining:

                # prepare players for a new subround
                for player in self.FPlayers:
                    player.NewSubRound()

                # Make every group fire
                for group in self.FGroupList:
                    if group.Fight2():
                        AmmoRemaining = True

            if not self.CanFight():
                Result := False
                break
         
        return Result
        
    def EndFight(self):
        # battle is over
        for player in self.FPlayers:
            player.Over()

        # Sort groups by owner
        SortList(FGroupList, SortGroupsByOwnerId)

        for group in self.FGroupList:
            for kill in group.FKillList:
                self.FKillLis.append(kill)

        self.FBattleEnd := timezone.now()
    
    # Return if a fight can happen
    # no fight can happen if everyone is friend
    def CanFight(self):
        for player in self.FPlayers:
            if player.FShipCount > 0:
                for enemy in player.FEnemies:
                    if enemy.FShipCount > 0:
                        return True

        return False
        
    # Return whether it hits or not
    def Fire(self, Ship, Target, ChanceToHit, Damage):

        Result := False

        if FCombatLogEnabled then
            if (Ship.Owner.FLastLog = nil) or (Ship.Owner.FLastLog.ShipId <> Ship.FId) or (Ship.Owner.FLastLog.TargetPlayerId <> Target.Owner.Id) or (Ship.Owner.FLastLog.TargetShipId <> Target.FId) then
                Ship.Owner.FLastLog := TCombatLog.Create
                Ship.Owner.FLastLog.PlayerId := Ship.Owner.FId
                Ship.Owner.FLastLog.ShipId := Ship.FId
                Ship.Owner.FLastLog.TargetPlayerId := Target.Owner.FId
                Ship.Owner.FLastLog.TargetShipId := Target.FId
                FCombatLog.Add(Ship.Owner.FLastLog)

        X := Random
        if X > ChanceToHit then
            Inc(Ship.FMiss)
            Exit // Missed !

        Inc(Ship.FHit)

        Result := True

        if Target.FUnitShield > 0 then Damage := Damage * 0.75

        if Damage > Target.FUnitShield then
            Ship.FDamages := Ship.FDamages + Target.FUnitShield
            Damage := Damage - Target.FUnitShield

            Target.FUnitShield := 0

            Damage := Damage * Ship.Fmult_damage

            if Damage > Target.FUnitHull then
                Ship.FDamages := Ship.FDamages + Target.FUnitHull
                Target.FUnitHull := 0
            else
                Ship.FDamages := Ship.FDamages + Damage
                Target.FUnitHull := Target.FUnitHull - Damage

            if Target.FUnitHull = 0 then
                ShipDestroyed(Target, Ship)
        else
            Target.FUnitShield := Target.FUnitShield - Damage
            Ship.FDamages := Ship.FDamages + Damage

    def GetDestroyedShips(self, index: Integer):
        Result := FKillList[index]

    def GetDestroyedShipsCount(self):
        Result := Length(FKillList)

    def GetPlayer(self, Id: Cardinal):
        // retrieve combatant if already exists
        for I := 0 to FPlayers.Count-1 do
            if TPlayer(FPlayers[I]).Id = Id then
                Result := TPlayer(FPlayers[I])
                Exit

        // Create a new combatant
        Result := TPlayer.Create(Self, Id)

        FPlayers.Add(Result)

        // Add it as an enemy for other combatant
        for I := 0 to FPlayers.Count-1 do
            if FPlayers[I] <> Result then
                TPlayer(FPlayers[I]).FEnemies.Add(Result)
                Result.FEnemies.Add(FPlayers[I])

    def NewRound(self):
        Inc(FRounds)

        // Notice each opponent that a new round begin
        for I := 0 to FPlayers.Count-1 do
            TPlayer(FPlayers[I]).NewRound

        if FCombatLogEnabled then
            LLog := TCombatLog.Create
            LLog.Round := FRounds

            FCombatLog.Add(LLog)

    def SetRelation(self, Ownerid1, Ownerid2):
        P1 := GetPlayer(Ownerid1)
        P2 := GetPlayer(Ownerid2)

        P1.FEnemies.Remove(P2)
        P2.FEnemies.Remove(P1)

    def ShipDestroyed(self, Target, ByGroup):
        Player := TPlayer(Target.FOwner)

        Target.ShipDestroyed

        ByGroup.EnemyShipDestroyed(Target)

    # sort the groups by "first shooter" order
    def SortGroupsByFirstShooter(self, Ship1, Ship2):
        if Ship1.FTech > Ship2.FTech then
            Result := 1
        else
            if Ship1.FTech < Ship2.FTech then
                Result := -1
            else
                if Ship1.FWeapon_ammo > Ship2.FWeapon_ammo then
                    Result := 1
                else
                    if Ship1.FWeapon_ammo < Ship2.FWeapon_ammo then
                        Result := -1
                    else
                        Result := 0

    def SortGroupsByOwnerId(self, Ship1, Ship2):
        if Ship1.Owner.Id < Ship2.Owner.Id then
            Result := -1
        else
            if Ship1.Owner.Id > Ship2.Owner.Id then
                Result := 1
            else
                Result := 0
 
def DamageTypes(EM, Explosive, Kinetic, Thermal):
begin
  Result.EM := EM
  Result.Explosive := Explosive
  Result.Kinetic := Kinetic
  Result.Thermal := Thermal
end

def ModTypes(Hull, Damage, Handling, Shield, Tracking_speed):
begin
  Result.Damage := Damage
  Result.Handling := Handling
  Result.Hull := Hull
  Result.Shield := Shield
  Result.Tracking_speed := Tracking_speed
end

def QuickSort(SortList, SCompare):
var
  I, J: Integer
  P, T: Pointer
begin
  repeat
    I := L
    J := R
    P := SortList^[(L + R) shr 1]
    repeat
      while SCompare(SortList^[I], P) < 0 do
        Inc(I)
      while SCompare(SortList^[J], P) > 0 do
        Dec(J)
      if I <= J then
      begin
        T := SortList^[I]
        SortList^[I] := SortList^[J]
        SortList^[J] := T
        Inc(I)
        Dec(J)
      end
    until I > J
    if L < J then
      QuickSort(SortList, L, J, SCompare)
    L := I
  until I >= R
end

def SortList(List, Compare):
begin
  if (List <> nil) and (List.List <> nil) and (List.Count > 0) then
    QuickSort(List.List, 0, List.Count-1, Compare)
end

def GetChanceToHit(WeaponTracking, TargetHandling: Extended Tech, TargetTech: Byte): Extended
var
  ChanceHit, ChanceDodge, ChanceEvade: Single
begin
  if TargetHandling = 1 then
  begin
    Result := 1.0
    Exit
  end

  ChanceHit := WeaponTracking / 1000
  ChanceDodge := TargetHandling / 1000
  ChanceEvade := (TargetHandling - WeaponTracking) / 1000

  if ChanceHit > 1 then
  begin
    ChanceDodge := ChanceDodge - (ChanceHit-1)
    ChanceHit := 1
  end

  while Tech < TargetTech do
  begin
    ChanceHit := ChanceHit * 0.85

    Inc(Tech)
  end

  while Tech > TargetTech do
  begin
    ChanceHit := ChanceHit * 1.10
    Dec(Tech)
  end

  if ChanceDodge < 0 then ChanceDodge := 0
  if ChanceDodge > 0.90 then ChanceDodge := 0.90

  if ChanceEvade < 0 then ChanceEvade := 0
  if ChanceEvade > 0.90 then ChanceEvade := 0.90

  Result :=  ChanceHit * (1-ChanceDodge) * (1-ChanceEvade)

  if Result > 1 then Result := 1
  if Result = 0 then Result := 0.0000001
{
  Result := (WeaponTracking - TargetHandling) / 1000
  if Result > 1 then Result := 1
  if Result <= 0 then Result := 0.0000001
  }
end

# Compute damage according to resistance
def CompDamage(Damage, Resistance: Smallint): Extended
var
  Protection: Extended
begin
  // bigger damage reduces damage reduction
  // 100 damage reduce resistance by 10%
  //Resistance := Resistance - Damage / 10

  Result := Damage

  // Additional damage recution
  // damage = 1
  // resist = 20 (1/2 = 50% reduc)
  Protection := Resistance/10
  if Protection > 0 then
  begin
    if Result < Protection then Result := Result*(Result/Protection)
  end

  Result := Max(Result * (1 - Resistance/100), 0)
end

def GetWeaponDamage(WeaponDamage, ShipResistance: TDamageTypes): Extended
begin
  if (WeaponDamage.EM = 0) and (WeaponDamage.Explosive = 0) and (WeaponDamage.Kinetic = 0) and (WeaponDamage.Thermal = 0) then
  begin
    Result := 0
    Exit
  end

  if (ShipResistance.EM = 0) and (ShipResistance.Explosive = 0) and (ShipResistance.Kinetic = 0) and (ShipResistance.Thermal = 0) then
  begin
    Result := WeaponDamage.EM + WeaponDamage.Explosive + WeaponDamage.Kinetic + WeaponDamage.Thermal
    Exit
  end

  Result := CompDamage(WeaponDamage.EM, ShipResistance.EM) +
            CompDamage(WeaponDamage.Explosive, ShipResistance.Explosive) +
            CompDamage(WeaponDamage.Kinetic, ShipResistance.Kinetic) +
            CompDamage(WeaponDamage.Thermal, ShipResistance.Thermal)
end

def AverageHitsToKill(WeaponDamage: TDamageTypes WeaponTrackingSpeed, TargetHull, TargetShield, TargetHandling: Extended TargetResistance: TDamageTypes Tech, TargetTech: Byte): Extended
var
  total_hp: Extended
  damage: Extended
begin
  total_hp := TargetHull + TargetShield
  damage := Min(GetWeaponDamage(WeaponDamage, TargetResistance), total_hp)

  Result := total_hp / ( Max(damage, 0.00001) * GetChanceToHit(WeaponTrackingSpeed, TargetHandling, Tech, TargetTech) )

  if Result = 0 then Result := MaxInt
end

def AverageHitsOn(WeaponDamage: TDamageTypes WeaponTrackingSpeed, TargetHull, TargetShield, TargetHandling: Extended TargetResistance: TDamageTypes Tech, TargetTech: Byte): Extended
var
  total_hp: Extended
  damage: Extended
begin
  total_hp := TargetHull + TargetShield
  damage := Min(GetWeaponDamage(WeaponDamage, TargetResistance), total_hp)

  Result := Max(damage, 0.00001) * GetChanceToHit(WeaponTrackingSpeed, TargetHandling, Tech, TargetTech)
end

def ShuffleList(List: TList)
var
  I: Integer
  Count: Integer
  B: Boolean
begin
  Count := List.Count
  B := False

  for I := 0 to Count-1 do
  begin
    List.Exchange(I, Random(Count))
    if B then
    begin
      List.Exchange(I, (Count-1 + I) div 2)
      B := False
    end
    else
      B := True
  end
end

class TPlayer:

    def AddShip(Fleetid, Shipid: Cardinal
      Hull, Shield: Cardinal
      handling, weapon_ammo, weapon_tracking_speed, weapon_turrets: Word weapon_damage: TDamageTypes
      Mods: TModTypes Resistances: TDamageTypes
      Quantity: Cardinal FireAtWill: Boolean Tech: Byte)
    var
      Grp: TShipsGroup
    begin
      FAggressive := FAggressive or FireAtWill

      Grp := TShipsGroup.Create(Self, Fleetid, Shipid, Hull, Shield, Handling,
                                weapon_ammo, weapon_tracking_speed, weapon_turrets, weapon_damage,
                                Mods, Resistances,
                                Quantity, Tech)
      FGroups.Add(Grp)
      FBattle.FGroupList.Add(Grp)
    end

    def Create(Battle: TBattle AId: Cardinal)
    begin
      FAggressive := False

      FBattle := Battle
      FId := AId

      FEnemies := TList.Create
      FEnemyGroups := TList.Create

      FShipCount := 0

      FGroups := TList.Create

      FIsWinner := False

      FShipActivations := 0
      FSkipEvery := 0
    end

    def Destroy
    var
      I: Integer
    begin
      FEnemies.Free
      FEnemyGroups.Free

      for I := 0 to FGroups.Count-1 do
        TShipsGroup(FGroups[I]).Free
      FGroups.Free

      inherited
    end

    def Fight2(): Boolean
    var
      I: Integer
    begin
      Result := False

      for I := 0 to FGroups.Count-1 do
        if TShipsGroup(FGroups[I]).Fight2() then
          Result := True
    end

    def Init
    var
      I, J: Integer
      P: TPlayer
    begin
      // Remove enemies that are not aggressive if we are not aggressive
      if not FAggressive then
      begin
        for I := FEnemies.Count-1 downto 0 do
        begin
          if not TPlayer(FEnemies[I]).FAggressive then
            FEnemies.Delete(I)
        end
      end

      // Initialize the list of enemy groups
      for I := 0 to FEnemies.Count-1 do
      begin
        P := TPlayer(FEnemies[I])

        for J := 0 to P.FGroups.Count-1 do
          FEnemyGroups.Add(P.FGroups[J])
      end

      ShuffleList(FEnemyGroups)

      // Init the groups
      for I := 0 to FGroups.Count-1 do
        TShipsGroup(FGroups[I]).Init
    end

    # Call NewRound for every ship group
    def NewRound
    var
      I: Integer
    begin
      for I := 0 to FGroups.Count-1 do
        TShipsGroup(FGroups[I]).NewRound
    end

    # Call NewSubRound for every ship group
    def NewSubRound
    var
      I: Integer
    begin
      for I := 0 to FGroups.Count-1 do
        TShipsGroup(FGroups[I]).NewSubRound
    end

    # Called when battle is over
    def Over
    var
      I: Integer
      Grp: TShipsGroup
    begin
      FIsWinner := False

      // Check if there are any enemy left
      for I := 0 to FEnemyGroups.Count-1 do
      begin
        Grp := TShipsGroup(FEnemyGroups[I])

        if Grp.Before > Grp.Loss then
          Exit
      end

      // Check that some ships remain to be declared "winner"
      for I := 0 to FGroups.Count-1 do
      begin
        Grp := TShipsGroup(FGroups[I])
        if Grp.FBefore > Grp.Loss then
        begin
          FIsWinner := True
          Exit
        end
      end
    end

    def ShipDestroyed(Target: TShipsGroup)
    begin
      Dec(FShipCount)
    end

class TShipsGroup:

    def Create(Owner: TPlayer Fleetid, Shipid: Cardinal
      Hull, Shield: Cardinal
      Handling, Weapon_ammo, Weapon_tracking_speed, Weapon_turrets: Word Weapon_damage: TDamageTypes
      Mods: TModTypes Resistances: TDamageTypes
      Quantity: Cardinal Tech: Byte)
    var
      I: Integer
    begin
      FOwner := Owner
      FId := ShipId

      FTech := Tech

      FRemainingShips := Quantity

      Inc(FOwner.FShipCount, Quantity)

      FShipLoss := 0

      FKilled := 0

      // Assign ship stats
      FFleetid := Fleetid
      FId := Shipid
      FHull := Hull

      FResistances := Resistances
      FWeapon_damage := Weapon_damage

      FBaseHandling := Handling
      FBaseHull := Hull
      FBaseShield := Shield
      FBaseWeapon_tracking_speed := Weapon_tracking_speed


      // Assign raw bonus
      Fmod_hull := Mods.Hull
      Fmod_shield := Mods.Shield
      Fmod_handling := Mods.Handling
      Fmod_tracking_speed := Mods.Tracking_speed
      Fmod_damage := Mods.Damage


      Fmult_hull := Fmod_hull/100

      // compute the effective multiplicator for each bonus
    {
      if Fmod_shield > 100 then
        Fmult_shield := (100 + (Fmod_shield-100)/2) / 100
      else   }
        Fmult_shield := Fmod_shield/100

      Fmult_handling := (100 + (Fmod_handling-100)/10) / 100
      Fmult_tracking_speed := (100 + (Fmod_tracking_speed-100)/10) / 100

      if Fmod_damage > 100 then
        Fmult_damage := (100 + (Fmod_damage-100)/10) / 100
      else
        Fmult_damage := Fmod_damage/100

      //
      // Compute ship protection : shield < 100% can decrease it
      //
      FHull := Hull*Fmult_hull
      FShield := Shield*Fmult_shield          // compute the value of the shield
      FHandling := Trunc(Handling*Fmult_handling)// Max(Handling*Fmult_handling, 1)
      if FHandling <= 1 then FHandling := 1


      FWeaponDamages := (weapon_damage.EM+weapon_damage.Explosive+weapon_damage.Kinetic+weapon_damage.Thermal) * Weapon_turrets * Log10(1+Weapon_tracking_speed)// / 10

      FWeapon_ammo := Weapon_ammo
      FWeapon_tracking_speed := Trunc(Weapon_tracking_speed*Fmult_tracking_speed)//mod_tracking_speed/100)
      FWeapon_turrets := Weapon_turrets


      FPrecision := Weapon_tracking_speed

      // Compute the type of target we want for this group
      FBestHandlingTarget := Trunc(FPrecision * 1.5)

      FHasPriorityTargets := True

      FUnitHull := FHull
      FUnitShield := FShield

      FBefore := Quantity
    end

    def Destroy
    {var
      I: Integer}
    begin
    {
      for I := 0 to FToFree.Count-1 do
        Dispose(FToFree[I])

      FToFree.Free
      FShips.Free
      FTargets.Free

      Dispose(FMainShip)
    }
      inherited
    end

    def PrioritySort(Ship1, Ship2: TShipsGroup): Integer
    var
      Sc1, Sc2: Extended
    begin
    {
      Sc1 := ( FWeapon_turrets / AverageHitsToKill(FWeapon_damage, FBaseWeapon_tracking_speed, Ship1.Group.FHull, Ship1.Group.FBaseShield, Ship1.Group.FBaseHandling, Ship1.Group.FResistances) ) *
             ( Ship1.Group.FWeapon_turrets / AverageHitsToKill(Ship1.Group.FWeapon_damage, Ship1.Group.FBaseWeapon_tracking_speed, FHull, FBaseShield, FBaseHandling, FResistances) )

      Sc2 := ( FWeapon_turrets / AverageHitsToKill(FWeapon_damage, FBaseWeapon_tracking_speed, Ship2.Group.FHull, Ship2.Group.FBaseShield, Ship2.Group.FBaseHandling, Ship2.Group.FResistances) ) *
             ( Ship2.Group.FWeapon_turrets / AverageHitsToKill(Ship2.Group.FWeapon_damage, Ship2.Group.FBaseWeapon_tracking_speed, FHull, FBaseShield, FBaseHandling, FResistances) )
    }

      Sc1 := AverageHitsOn(FWeapon_damage, FBaseWeapon_tracking_speed, Ship1.FBaseHull, Ship1.FBaseShield, Ship1.FBaseHandling, Ship1.FResistances, FTech, Ship1.FTech)
      Sc2 := AverageHitsOn(FWeapon_damage, FBaseWeapon_tracking_speed, Ship2.FBaseHull, Ship2.FBaseShield, Ship2.FBaseHandling, Ship2.FResistances, FTech, Ship2.FTech)

      if Sc1 > Sc2 then
        Result := -1
      else
      if Sc1 < Sc2 then
        Result := 1
      else
        Result := 0
    end

    def FindTarget: TShipsGroup
    var
      I, J, C: Integer
      Grp: TShipsGroup
      TargetList: TList
    begin
      TargetList := TList.Create

      // Retrieve the possible targets from the list of enemy ships

      for I := 0 to FOwner.FEnemyGroups.Count-1 do
      begin
        Grp := TShipsGroup(FOwner.FEnemyGroups[I])

        if (Grp.FWeaponDamages > 0) and (Grp.FRemainingShips > 0) then
        begin
          TargetList.Add(Grp)
        end
      end

      // If no prioritary targets, fill the secondary targets
      if TargetList.Count = 0 then
      begin
        FHasPriorityTargets := False

        for I := 0 to FOwner.FEnemyGroups.Count-1 do
        begin
          Grp := TShipsGroup(FOwner.FEnemyGroups[I])

          if (Grp.FRemainingShips > 0) then
          begin
            TargetList.Add(Grp)
          end
        end
      end

      if TargetList.Count > 0 then
      begin
        // Sort the list by priority
        ShuffleList(TargetList)
        SortList(TargetList, PrioritySort)

        Result := TargetList[0]
      end
      else
        Result := nil

      TargetList.Free
    end

    def GetTarget: TShipsGroup
    var
      Index: Integer
      A, B: Int64}
    begin
      if (FChangeTargetIn <= 0) or ((FCurrentTarget <> nil) and (FCurrentTarget.FRemainingShips <= 0)) then //or ((GetWeaponPenetration(FWeapon_power, FCurrentTarget.Group.FProtection) = 0) and (FCurrentTarget.Shield = 0)) then
        FCurrentTarget := nil

      if FCurrentTarget = nil then
      begin
        FCurrentTarget := FindTarget

        FChangeTargetIn := 10
      end
      Index := FTargets.Count-1

      while (FCurrentTarget = nil) and (Index >= 0) do
      begin
        FCurrentTarget := PShip(FTargets[Index])

        // Check if the target is still alive
        if FCurrentTarget.Hull = 0 then
        begin
          // Delete from our target list
          FTargets.Delete(Index)

          // If there's no more targets, try to re-fill it
          if Index = 0 then
          begin

            FillTargetList

    end

    def NewRound
    var
      I: Integer
    begin
      FRemainingAmmo := FWeapon_ammo
      FShipsForRound := FRemainingShips
    end

    def GetLoss: Integer
    begin
      Result := FShipLoss
    end

    def EnemyShipDestroyed(Group: TShipsGroup)
    var
      I: Integer
    begin
      Dec(FChangeTargetIn)

      Inc(FKilled)

      for I := 0 to High(FKillList) do
        if FKillList[I].DestroyedGroup = Group then
        begin
          Inc(FKillList[I].Count)
          Exit
        end

      I := Length(FKillList)
      SetLength(FKillList, I+1)
      FKillList[I].Group := Self
      FKillList[I].DestroyedGroup := Group
      FKillList[I].Count := 1
    end

    def Fight2(): Boolean
    var
      I: Cardinal
      LastTarget, Target: TShipsGroup
      Hit, Dmg: Extended
      A, B: Int64
    begin
      Result := False
      if FRemainingAmmo = 0 then Exit

      I := FShipsForRound * Min(FRemainingAmmo, FWeapon_Turrets)

      // remove number of ammo used
      if FRemainingAmmo >= FWeapon_Turrets then
        Dec(FRemainingAmmo, FWeapon_Turrets)
      else
        FRemainingAmmo := 0

      LastTarget := nil
      Hit := 0
      Dmg := 0

      while I > 0 do
      begin


        Target := GetTarget

        if Target = nil then Break  // Target = nil when no more targets
        if (LastTarget <> Target) then
        begin
          Hit := GetChanceToHit(FWeapon_tracking_speed, Target.FHandling, FTech, Target.FTech)
          Dmg := GetWeaponDamage(FWeapon_damage, Target.FResistances)
          LastTarget := Target
        end

        Result := True

        FOwner.FBattle.Fire(Self, Target, Hit, Dmg)

        Dec(I)
      end
    end

    def GetDamages: Integer
    begin
      Result := Round(Min(FDamages, 2000000000))
    end

    def GetKill(index: Integer): TKill
    begin
      Result := FKillList[index]
    end

    def ShipDestroyed()
    begin
      Dec(FRemainingShips)
      Inc(FShipLoss)

      // Remove ship from owner shiplist
      FOwner.ShipDestroyed(Self)

      if FRemainingShips > 0 then
      begin
        FUnitHull := FHull
        FUnitShield := FShield
      end
    end
