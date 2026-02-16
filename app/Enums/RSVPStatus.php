<?php

namespace App\Enums;

enum RSVPStatus: string
{
    case PENDING = 'pending';
    case CONFIRMED = 'confirmed';
    case DECLINED = 'declined';
}
