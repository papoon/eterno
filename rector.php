<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;
use Rector\Set\ValueObject\LevelSetList;
use Rector\Set\ValueObject\SetList;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/app',
        __DIR__ . '/database',
    ])
    ->withSets([
        // PHP 8.3 upgrade rules
        LevelSetList::UP_TO_PHP_83,
        
        // Code quality improvements
        SetList::CODE_QUALITY,
        
        // Type declarations
        SetList::TYPE_DECLARATION,
        
        // Dead code removal
        SetList::DEAD_CODE,
        
        // Early return patterns
        SetList::EARLY_RETURN,
    ])
    ->withSkip([
        // Skip vendor and generated files
        __DIR__ . '/vendor',
        __DIR__ . '/storage',
        __DIR__ . '/bootstrap/cache',
    ])
    ->withImportNames(
        importShortClasses: false,
        removeUnusedImports: true
    );
