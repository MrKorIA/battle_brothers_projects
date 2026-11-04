//::VanillaPlus.HooksMod.hook("scripts/factions/faction", function(q) {
//
//	// Хукаем именно метод update, где происходит падение
//	q.update = @(__original) function( _isNewCampaign = false, _ignoreDelay = false )
//	{
//if (!this.m.IsActive)
//		{
//			return;
//		}
//
//		if (this.m.Deck.len() == 0)
//		{
//			return;
//		}
//
//		if (!_ignoreDelay && this.m.LastActionTime + this.Const.Factions.GlobalMinDelay > this.Time.getVirtualTimeF())
//		{
//			return;
//		}
//
//		if (!_ignoreDelay)
//		{
//			this.m.LastActionTime = this.Time.getVirtualTimeF();
//		}
//
//		this.onUpdateRoster();
//		this.onUpdate();
//
//		foreach( u in this.m.Units )
//		{
//			if (u.getTroops().len() == 0)
//			{
//				u.die();
//			}
//
//			if (!_ignoreDelay && this.m.Settlements.len() != 0)
//			{
//				if (u.getFlags().has("IsMercenaries"))
//				{
//					continue;
//				}
//
//				if (u.isAlive() && !u.getController().hasOrders())
//				{
//				    try {
//
//                        local home = this.getNearestSettlement(u.getTile());
//                        local move = this.new("scripts/ai/world/orders/move_order");
//                        move.setDestination(home.getTile());
//                        local despawn = this.new("scripts/ai/world/orders/despawn_order");
//                        u.getController().addOrder(move);
//                        u.getController().addOrder(despawn);
//
//				    }
//				    catch (exception) {
//				        ::logInfo("[Vanilla+ Фикс] Из фракции " + this.m.Name + " (ID: " + this.m.ID + ") успешно удален мертвый квестовый призрак");
//				        local myArray = u.getTooltip();
//                        if (myArray != null && typeof myArray == "array")
//                        {
//                            ::logInfo("--- РАСПАКОВКА МАССИВА ---");
//                            foreach( index, value in myArray )
//                            {
//                                if (value == null)
//                                {
//                                    ::logInfo(format("  [%d] = NULL", index));
//                                }
//                                else if (typeof value == "table")
//                                {
//                                        		::logInfo("--- РАСПАКОВКА ВНУТРЕННЕЙ ТАБЛИЦЫ 'myArray' ---");
//                                        		foreach( subKey, subValue in value )
//                                        		{
//                                        			try
//                                        			{
//                                        				if (subValue == null)
//                                        				{
//                                        					::logInfo(format("  m.%s = NULL", subKey));
//                                        				}
//                                        				else if (typeof subValue == "table" || typeof subValue == "array")
//                                        				{
//                                        					::logInfo(format("  m.%s = [%s с размером %d]", subKey, typeof subValue, subValue.len()));
//                                        				}
//                                        				else if (typeof subValue == "instance")
//                                        				{
//                                        					::logInfo(format("  m.%s = [Экземпляр класса %s]", subKey, subValue.getclassname()));
//                                        				}
//                                        				else
//                                        				{
//                                        					::logInfo(format("  m.%s = %s", subKey, subValue.tostring()));
//                                        				}
//                                        			}
//                                        			catch(e)
//                                        			{
//                                        				::logInfo(format("  m.%s = [Ошибка чтения значения]", subKey));
//                                        			}
//                                        		}
//                                        		::logInfo("----------------------------------------");
//                                }
//                                else if (typeof value == "array")
//                                {
//                                    ::logInfo(format("  [%d] = [Array с размером %d]", index, value.len()));
//                                }
//                                else if (typeof value == "instance")
//                                {
//                                    // Если внутри экземпляр класса, пишем его имя (например, world_tile)
//                                    local className = ("getclassname" in value) ? value.getclassname() : "unknown_instance";
//                                    ::logInfo(format("  [%d] = [Instance класса %s]", index, className));
//                                }
//                                else
//                                {
//                                    // Для строк, чисел и булевых значений вывод будет обычным текстом
//                                    ::logInfo(format("  [%d] = %s", index, value.tostring()));
//                                }
//                            }
//                            }
//                        this.removeUnit(u);
//				    }
//				}
//			}
//		}
//
//		local score = 0;
//		local actionToFire;
//
//		for( local i = 0; i < this.m.Deck.len(); i = ++i )
//		{
//			this.m.Deck[i].update(_isNewCampaign);
//
//			if (this.m.Deck[i].getScore() <= 0)
//			{
//			}
//			else
//			{
//				score = score + this.m.Deck[i].getScore();
//			}
//		}
//
//		if (score == 0)
//		{
//			return;
//		}
//
//		local pick = this.Math.rand(1, score);
//
//		for( local i = 0; i < this.m.Deck.len(); i = ++i )
//		{
//			if (this.m.Deck[i].getScore() <= 0)
//			{
//			}
//			else
//			{
//				if (pick <= this.m.Deck[i].getScore())
//				{
//					actionToFire = this.m.Deck[i];
//					break;
//				}
//
//				pick = pick - this.m.Deck[i].getScore();
//			}
//		}
//
//		if (actionToFire == null)
//		{
//			return;
//		}
//
//		actionToFire.execute(_isNewCampaign);
//
////		try
////		{
////		 // Перед тем как запустить ванильный апдейт, проверяем массив юнитов
////                local healthyUnits = [];
////
////                foreach( u in this.m.Units )
////                {
////                    // Если отряд существует, и у него ЕСТЬ метод getTile (он физически жив на карте)
////                    if (u != null && this.m.ID != "3" && ("getTile" in u))
////                    {
////                        healthyUnits.push(u); // Сохраняем его
////                    }
////                    else
////                    {
////                        // Если это "призрак" без getTile, мы просто молча игнорируем его и не пускаем в healthyUnits.
////                        // Таким образом, мы очищаем память фракции от мертвых квестовых контрактов!
////                        local unitName = (u != null && "getName" in u) ? u.getName() : "Неизвестный отряд";
////                        ::logInfo("[Vanilla+ Фикс] Из фракции " + this.m.Name + " (ID: " + this.m.ID + ") успешно удален мертвый квестовый призрак: " + unitName);
////                    }
////                }
////
////                // Перезаписываем список юнитов фракции только живыми отрядами
////                this.m.Units = healthyUnits;
////			// Пытаемся выполнить ванильный апдейт фракции
////			__original(_isNewCampaign, _ignoreDelay);
////		}
////		catch (exception)
////		{
////			::logInfo("==================================================");
////			::logInfo("[КРИТИЧЕСКИЙ ДЕБАГ] Поймана ошибка getTile во фракции ID: " + this.m.ID + " (" + this.m.Name + ")");
////
////			// Проверяем все юниты этой фракции, чтобы найти сломанный
////			foreach( index, u in this.m.Units )
////			{
////				if (u == null)
////				{
////					::logInfo(format("Юнит [%d]: Вообще равен NULL!", index));
////					continue;
////				}
////
////				// Проверяем тип данных. Должен быть Instance (отряд на карте)
////				::logInfo(format("Юнит [%d]: Тип данных = %s, Имя отряда = %s", index, typeof u, ("getName" in u) ? u.getName() : "Нет имени"));
////
////				// Проверяем наличие метода getTile
////				if (!("getTile" in u))
////                {
////                	::logInfo(format("!!! НАЙДЕН ВИНОВНИК !!! Юнит [%d] не имеет метода getTile. Дамп полей:", index));
////
////                	// 1. Сначала выводим базовые методы (для очистки совести)
////                	foreach( k, v in u )
////                	{
////                		if (k != "m") {
////                			try { ::logInfo(format("  %s = %s", k, v.tostring())); } catch(e) {}
////                		}
////                	}
////::logInfo(u.getTooltip());
////local myArray = u.getTooltip();
////if (myArray != null && typeof myArray == "array")
////{
////    ::logInfo("--- РАСПАКОВКА МАССИВА ---");
////    foreach( index, value in myArray )
////    {
////        if (value == null)
////        {
////            ::logInfo(format("  [%d] = NULL", index));
////        }
////        else if (typeof value == "table")
////        {
////                		::logInfo("--- РАСПАКОВКА ВНУТРЕННЕЙ ТАБЛИЦЫ 'myArray' ---");
////                		foreach( subKey, subValue in value )
////                		{
////                			try
////                			{
////                				if (subValue == null)
////                				{
////                					::logInfo(format("  m.%s = NULL", subKey));
////                				}
////                				else if (typeof subValue == "table" || typeof subValue == "array")
////                				{
////                					::logInfo(format("  m.%s = [%s с размером %d]", subKey, typeof subValue, subValue.len()));
////                				}
////                				else if (typeof subValue == "instance")
////                				{
////                					::logInfo(format("  m.%s = [Экземпляр класса %s]", subKey, subValue.getclassname()));
////                				}
////                				else
////                				{
////                					::logInfo(format("  m.%s = %s", subKey, subValue.tostring()));
////                				}
////                			}
////                			catch(e)
////                			{
////                				::logInfo(format("  m.%s = [Ошибка чтения значения]", subKey));
////                			}
////                		}
////                		::logInfo("----------------------------------------");
////        }
////        else if (typeof value == "array")
////        {
////            ::logInfo(format("  [%d] = [Array с размером %d]", index, value.len()));
////        }
////        else if (typeof value == "instance")
////        {
////            // Если внутри экземпляр класса, пишем его имя (например, world_tile)
////            local className = ("getclassname" in value) ? value.getclassname() : "unknown_instance";
////            ::logInfo(format("  [%d] = [Instance класса %s]", index, className));
////        }
////        else
////        {
////            // Для строк, чисел и булевых значений вывод будет обычным текстом
////            ::logInfo(format("  [%d] = %s", index, value.tostring()));
////        }
////    }
////    ::logInfo("--------------------------");
////}
////                	// 2. ИСПРАВЛЕНО: Глубокий дамп внутренней таблицы 'm'
////                	if ("m" in u && typeof u.m == "table")
////                	{
////                		::logInfo("--- РАСПАКОВКА ВНУТРЕННЕЙ ТАБЛИЦЫ 'm' ---");
////                		foreach( subKey, subValue in u.m )
////                		{
////                			try
////                			{
////                				if (subValue == null)
////                				{
////                					::logInfo(format("  m.%s = NULL", subKey));
////                				}
////                				else if (typeof subValue == "table" || typeof subValue == "array")
////                				{
////                					::logInfo(format("  m.%s = [%s с размером %d]", subKey, typeof subValue, subValue.len()));
////                				}
////                				else if (typeof subValue == "instance")
////                				{
////                					::logInfo(format("  m.%s = [Экземпляр класса %s]", subKey, subValue.getclassname()));
////                				}
////                				else
////                				{
////                					::logInfo(format("  m.%s = %s", subKey, subValue.tostring()));
////                				}
////                			}
////                			catch(e)
////                			{
////                				::logInfo(format("  m.%s = [Ошибка чтения значения]", subKey));
////                			}
////                		}
////                		::logInfo("----------------------------------------");
////                	}
////                }
////
////			}
////			::logInfo("==================================================");
////
////			// Бросаем ошибку дальше, чтобы игра показала лог, но теперь с нашими данными
////			throw exception;
////		}
//	}
//});
